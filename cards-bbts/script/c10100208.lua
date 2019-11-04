if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Krana Vu, Surveyor
function c10100208.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,10100208)
	e1:SetCondition(c10100208.condition1)
	e1:SetCost(c10100208.cost1)
	e1:SetTarget(c10100208.target1)
	e1:SetOperation(c10100208.operation1)
	c:RegisterEffect(e1)
	--Revive
	local e2=bbts.krana_revive(c)
	c:RegisterEffect(e2)
end
function c10100208.filter1(c,tp)
  return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x15c)
end
function c10100208.condition1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsChainNegatable(ev) and g:IsExists(c10100208.filter1,1,nil,tp)
end
function c10100208.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c10100208.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10100208.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT) then
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end 
	end
end