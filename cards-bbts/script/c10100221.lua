if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Lehvak Va
function c10100221.initial_effect(c)
	--special summon
	local e1 = bbts.bohrokva_selfss(c,10100206)
	c:RegisterEffect(e1)
	--Negate activation
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10100221.condition2)
	e2:SetCost(c10100221.cost2)
	e2:SetTarget(c10100221.target2)
	e2:SetOperation(c10100221.operation2)
	c:RegisterEffect(e2)
	--Return
	local e3 = bbts.bohrokva_krana(c)
	c:RegisterEffect(e3)
end
function c10100221.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x15c)
end
function c10100221.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100221.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) and rp==1-tp
end
function c10100221.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(), REASON_COST)
end
function c10100221.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsChainNegatable(ev) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10100221.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
