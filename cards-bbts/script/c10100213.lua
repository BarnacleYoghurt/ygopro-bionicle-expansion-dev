if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Krana Ja, Scout
function s.initial_effect(c)
	--Scout
	local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition1)
	e1:SetCost(s.cost1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--Summon
	local e2=bbts.krana_summon(c)
	c:RegisterEffect(e2)
end
function s.filter1(c)
  return c:IsFaceup() and c:IsSetCard(0xb08)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
  g:KeepAlive()
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
  e1:SetCode(EFFECT_DISABLE)
  e1:SetTarget(s.target1_1)
  e1:SetLabel(Duel.GetTurnCount()+1)
  e1:SetLabelObject(g)
  e1:SetReset(RESET_PHASE+PHASE_END,2)
  Duel.RegisterEffect(e1,tp)
end
function s.target1_1(e,c)
  local g=e:GetLabelObject()
	return Duel.GetTurnCount()==e:GetLabel() and g:IsExists(Card.IsCode,1,nil,c:GetCode())
end