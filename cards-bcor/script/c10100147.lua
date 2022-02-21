--Matoran Racer Onepu
local s,id=GetID()
function s.initial_effect(c)
  --Brag
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id+1000000)
	c:RegisterEffect(e2)
end
function s.filter1a(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToDeck()
end
function s.filter1b(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb01) and not c:IsPublic()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.filter1a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1a,tp,LOCATION_REMOVED,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 then
    local rg=Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_HAND,0,nil)
    if rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
      Duel.BreakEffect()
      rg=rg:Select(tp,1,rg:GetCount(),nil)
      Duel.ConfirmCards(1-tp,rg)
      Duel.ShuffleHand(tp)
      Duel.Recover(tp,rg:GetCount()*500,REASON_EFFECT)
    end
  end
end
function s.filter2(c,e,tp)
	return c:IsRace(RACE_BEAST) and c:IsLevelBelow(4) and c:IsSetCard(0xb06) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
    local tc=g:GetFirst()
    if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetDescription(3300)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
      e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
      e1:SetValue(LOCATION_REMOVED)
      tc:RegisterEffect(e1,true)
    end
		Duel.SpecialSummonComplete()
	end
end
