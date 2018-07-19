if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Krana Yo, Mole
function c10100209.initial_effect(c)
	--Equip
	local e1=bbts.krana_equip(c)
	c:RegisterEffect(e1)
	--Direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(bbts.krana_condition_equipped)
	c:RegisterEffect(e2)
	--Halve damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c10100209.condition3)
	e3:SetOperation(c10100209.operation3)
	c:RegisterEffect(e3)
	--Revive
	local e4=bbts.krana_revive(c)
	c:RegisterEffect(e4)
	--Summon
	local e5=bbts.krana_summon(c)
	c:RegisterEffect(e5)
end
function c10100209.condition3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	return c and c:IsSetCard(0x15c) and ep~=tp and Duel.GetAttacker()==c and Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c10100209.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end