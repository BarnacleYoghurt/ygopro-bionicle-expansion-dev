if not bcot then
    Duel.LoadScript("../util-bcot.lua")
end
if not bpev then
    Duel.LoadScript("../util-bpev.lua")
end
--Great Kanohi Kakama Nuva
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c)
    --Destroy if replaced
    local e1=bcot.kanohi_selfdestruct(c)
    c:RegisterEffect(e1)
    --Attack All
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetCondition(function(e) return bcot.kanohi_con(e,{0xb0c}) end)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Place Nuva Symbol & allow direct attacks
    local e4,chainfilter=bpev.kanohi_nuva_search(c,s.operation4,id)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,chainfilter)
    e4:SetDescription(aux.Stringid(id,0))
    c:RegisterEffect(e4)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(g) do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DIRECT_ATTACK)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end

