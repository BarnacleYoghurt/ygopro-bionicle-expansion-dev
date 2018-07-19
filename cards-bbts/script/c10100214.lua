if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Krana Bo, Sentinel
function c10100214.initial_effect(c)
	--Equip
	local e1=bbts.krana_equip(c)
	c:RegisterEffect(e1)
	--Check set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(bbts.krana_condition_equipped)
	e2:SetTarget(c10100214.target2)
	e2:SetOperation(c10100214.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Revive
	local e3=bbts.krana_revive(c)
	c:RegisterEffect(e3)
	--Summon
	local e4=bbts.krana_summon(c)
	c:RegisterEffect(e4)
end
function c10100214.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c10100214.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local cg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
		Duel.ConfirmCards(tp,cg)
	end
end
