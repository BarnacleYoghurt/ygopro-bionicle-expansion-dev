if not bcot then
    Duel.LoadScript("util-bcot.lua")
end
if not bpev then
    Duel.LoadScript("util-bpev.lua")
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
    --Set Nuva Trap & check hand
    local e4,chainfilter=bpev.kanohi_nuva_search_trap(c,s.operation4,id)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,chainfilter)
    e4:SetDescription(aux.Stringid(id,0))
    c:RegisterEffect(e4)
end
function s.condition2(e)
    local ec=e:GetHandler():GetEquipTarget()
    return bcot.kanohi_con(e,{0xb0c}) and ec:IsControler(e:GetOwnerPlayer())
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
	end
end
