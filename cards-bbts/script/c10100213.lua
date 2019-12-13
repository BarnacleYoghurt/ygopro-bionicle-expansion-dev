if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Krana Ja, Scout
function c10100213.initial_effect(c)
	--Scout
	local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(10100213,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10100213.condition1)
	e1:SetCost(c10100213.cost1)
	e1:SetOperation(c10100213.operation1)
	e1:SetCountLimit(1,10100213)
	c:RegisterEffect(e1)
	--Summon
	local e2=bbts.krana_summon(c)
	c:RegisterEffect(e2)
end
function c10100213.filter1(c)
  return c:IsFaceup() and c:IsSetCard(0x15c)
end
function c10100213.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c10100213.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100213.filter1, tp, LOCATION_MZONE, 0, 1, nil)
end
function c10100213.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
  g:KeepAlive()
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
  e1:SetCode(EFFECT_DISABLE)
  e1:SetTarget(c10100213.target1_1)
  e1:SetLabel(Duel.GetTurnCount()+1)
  e1:SetLabelObject(g)
  e1:SetReset(RESET_PHASE+PHASE_END,2)
  Duel.RegisterEffect(e1,tp)
end
function c10100213.target1_1(e,c)
  local g=e:GetLabelObject()
	return Duel.GetTurnCount()==e:GetLabel() and g:IsExists(Card.IsCode,1,nil,c:GetCode())
end