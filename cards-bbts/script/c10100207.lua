if not bbts_k then
	dofile "expansions/util-bbts.lua"
end
--Krana Xa, Swarm Commander
function c10100207.initial_effect(c)
	--Equip
	local e1=bbts_k.equip(c)
	c:RegisterEffect(e1)
	--Guard
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(bbts_k.condition_equipped)
	e2:SetOperation(c10100207.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Revive
	local e3=bbts_k.revive(c)
	c:RegisterEffect(e3)
	--Summon
	local e4=bbts_k.summon(c)
	c:RegisterEffect(e4)
end
function c10100207.limit2(e,rp,tp)
	return tp==rp
end
function c10100207.operation2(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x15c) then
		Duel.SetChainLimit(c10100207.limit2)
	end
end