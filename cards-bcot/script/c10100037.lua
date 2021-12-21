--Matoran Chronicler Takua
local s,id=GetID()
function s.initial_effect(c)
	--To deck
	local e1a=Effect.CreateEffect(c)
	e1a:SetDescription(aux.Stringid(id,0))
	e1a:SetCategory(CATEGORY_TODECK)
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1a:SetCode(EVENT_SUMMON_SUCCESS)
	e1a:SetProperty(EFFECT_FLAG_DELAY)
	e1a:SetTarget(s.target1)
	e1a:SetOperation(s.operation1)
	c:RegisterEffect(e1a)
  local e1b=e1a:Clone()
  e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e1b)
	--Excavate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
function s.filter1(c)
	return c:IsSetCard(0x1b01) and c:IsType(TYPE_MONSTER)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
    local tc=g:GetFirst()
    if tc:IsLocation(LOCATION_DECK) then
      Duel.ShuffleDeck(tp)
      Duel.MoveToDeckTop(tc)
    else
      Duel.HintSelection(g,true)
      Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
    end
    if not tc:IsLocation(LOCATION_EXTRA) then
      Duel.ConfirmDecktop(tp,1)
    end
    
    if tc:IsLocation(LOCATION_DECK) then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
      e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
      e1:SetRange(LOCATION_MZONE)
      e1:SetValue(tc:GetOriginalAttribute())
      e1:SetReset(RESET_EVENT+RESETS_STANDARD)
      e:GetHandler():RegisterEffect(e1)
    end
  end
end
function s.filter2(c,e,tp)
	return c:IsSetCard(0x1b01) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,6)
	local g=Duel.GetDecktopGroup(tp,6):Filter(s.filter2,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.ShuffleDeck(tp)
end
