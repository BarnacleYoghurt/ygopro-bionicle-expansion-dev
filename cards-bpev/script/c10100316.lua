if not bcot then
    Duel.LoadScript("../util-bcot.lua")
end
if not bpev then
    Duel.LoadScript("../util-bpev.lua")
end
--Great Kanohi Akaku Nuva
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c)
    --Destroy if replaced
    local e1=bcot.kanohi_selfdestruct(c)
    c:RegisterEffect(e1)
    --Hand Reveal
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	e2:SetCode(EFFECT_PUBLIC)
    e2:SetCondition(s.condition2)
	c:RegisterEffect(e2)
    --Place Nuva Symbol & allow direct attacks
    local e4,chainfilter=bpev.kanohi_nuva_search(c,s.operation4,id)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,chainfilter)
    e4:SetDescription(aux.Stringid(id,0))
    c:RegisterEffect(e4)
end
function s.condition2(e)
    local ec=e:GetHandler():GetEquipTarget()
    return bcot.kanohi_con(e,{0xb0c}) and ec:IsControler(e:GetOwnerPlayer())
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_HAND)
	e1:SetCode(EFFECT_PUBLIC)
    e1:SetCondition(function() return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 end)
    e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
