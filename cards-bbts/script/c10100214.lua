if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Krana Bo, Sentinel
function c10100214.initial_effect(c)
	--Banish in the dark
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1a:SetRange(LOCATION_HAND)
	e1a:SetCode(EVENT_DESTROYED)
	e1a:SetCondition(c10100214.condition1)
	e1a:SetCost(c10100214.cost1)
	e1a:SetTarget(c10100214.target1)
	e1a:SetOperation(c10100214.operation1)
	e1a:SetCountLimit(1,10100214)
	c:RegisterEffect(e1a)
  local e1b=e1a:Clone()
  e1b:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e1b)
	--Revive
	local e2=bbts.krana_revive(c)
	c:RegisterEffect(e2)
end
function c10100214.filter1(c,ec)
  return c:IsCode(ec:GetCode()) and c:IsAbleToRemove()
end
function c10100214.condition1(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x15c) and eg:GetCount()==1
end
function c10100214.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
  Duel.SendtoGrave(c,REASON_COST)
end
function c10100214.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c10100214.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
  local tg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  Duel.ConfirmCards(tp,tg)
  tg=tg:Filter(c10100214.filter1,nil,ec)
  if tg:GetCount()>0 then
    Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
  end
end
