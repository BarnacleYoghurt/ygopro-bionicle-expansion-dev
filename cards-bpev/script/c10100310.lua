if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Toa Nuva Kopaka
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Material
	Fusion.AddProcMix(c,true,true,10100005,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb0b))
	--Add Spell/Trap
	local e1=bpev.toa_nuva_search(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_MAIN_END)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Attack protection
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_FIELD)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetTargetRange(0,LOCATION_MZONE)
	e3a:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3a:SetCondition(s.condition3)
	e3a:SetValue(s.value3)
	c:RegisterEffect(e3a)
	--Targeting protection
	local e3b=Effect.CreateEffect(c)
	e3b:SetType(EFFECT_TYPE_FIELD)
	e3b:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3b:SetRange(LOCATION_MZONE)
	e3b:SetTargetRange(LOCATION_ONFIELD,0)
	e3b:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3b:SetCondition(s.condition3)
	e3b:SetTarget(s.value3)
	e3b:SetValue(aux.tgoval)
	c:RegisterEffect(e3b)
end
s.material_setcode={0xb02,0x1b02,0xb0b}
s.listed_series={0xb0b,0xb0c}
s.listed_names={10100005}
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=1 and Duel.IsMainPhase()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function s.condition3(e)
	return e:GetHandler():IsDefensePos()
end
function s.value3(e,c)
	return c~=e:GetHandler()
end