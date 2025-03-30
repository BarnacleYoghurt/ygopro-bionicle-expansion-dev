if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Toa Nuva Gali
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit() 
	--Fusion Material
	Fusion.AddProcMix(c,true,true,10100002,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb0b))
	--Add Spell/Trap
	local e1=bpev.toa_nuva_search(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
s.material_setcode={0xb02,0x1b02,0xb0b}
s.listed_series={0xb0b,0xb0c}
s.listed_names={10100002}
function s.filter2(c)
	return c:IsNegatableMonster() and c:IsType(TYPE_EFFECT)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter2(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:NegateEffects(c,RESET_PHASE+PHASE_END)
	end
end
