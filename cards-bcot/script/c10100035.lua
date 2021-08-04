--C.C. Matoran Kopeke
local s,id=GetID()
function s.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
  local e1b=e1:Clone()
  e1b:SetCode(EVENT_FLIP)
  c:RegisterEffect(e1b)
	--To Defense
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target2)
  e2:SetValue(s.value2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end
function s.filter1(c)
	return c:IsLevel(2) and c:IsRace(RACE_WARRIOR) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
      Duel.ConfirmCards(1-tp,g)
      Duel.BreakEffect()
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
      local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
      Duel.SendtoDeck(rg,nil,0,REASON_EFFECT)
    end
	end
end
function s.filter2(c,tp)
  return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x1b01) and not c:IsReason(REASON_REPLACE)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:IsCanTurnSet() and eg:IsExists(s.filter2,1,nil,tp) and not eg:IsContains(c) end
	return Duel.SelectYesNo(tp,aux.Stringid(id,1))
end
function s.value2(e,c)
	return s.filter2(c,e:GetHandlerPlayer())
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
end