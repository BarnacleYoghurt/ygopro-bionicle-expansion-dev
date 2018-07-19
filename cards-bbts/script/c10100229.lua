if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Kaita Ja
function c10100229.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCode3(c,10100202,10100205,10100206,true,true)
	c:EnableReviveLimit()
	--Equip Krana
	local e1=bbts.bohrokkaita_krana(c)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10100229.condition2)
	e2:SetCost(c10100229.cost2)
	e2:SetTarget(c10100229.target2)
	e2:SetOperation(c10100229.operation2)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=bbts.bohrokkaita_ss(c)
	c:RegisterEffect(e3)
end
function c10100229.filter2(c)
	return c:IsSetCard(0x15c) and c:IsReleasable()
end
function c10100229.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return tp~=rp and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10100229.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100229.filter2,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c10100229.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c10100229.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10100229.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end