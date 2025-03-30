if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Toa Nuva Tahu
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Material
	Fusion.AddProcMix(c,true,true,10100001,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb0b))
	--Add Spell/Trap
	local e1=bpev.toa_nuva_search(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
	--ATK to 0
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
s.material_setcode={0xb02,0x1b02,0xb0b}
s.listed_series={0xb0b,0xb0c}
s.listed_names={10100001}
function s.filter2(c)
  return c:IsFaceup() and c:IsAttackPos() and c:GetAttack()>0
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and
		(Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return s.filter2(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(tc:GetBaseAttack())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end

