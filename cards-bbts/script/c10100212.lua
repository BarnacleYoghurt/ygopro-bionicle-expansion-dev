if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Krana Ca. Clearance Worker
function c10100212.initial_effect(c)
	--Equip
	local e1=bbts.krana_equip(c)
	c:RegisterEffect(e1)
	--Protect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCondition(bbts.krana_condition_equipped)
	e2:SetTarget(c10100212.target2)
	e2:SetValue(c10100212.value2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Summon
	local e3=bbts.krana_summon(c)
	c:RegisterEffect(e3)
end
function c10100212.target2(e,c)
	return c:IsFaceup() and c:IsSetCard(0x15c)
end
function c10100212.value2(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end