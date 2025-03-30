if not bcot then
    Duel.LoadScript("util-bcot.lua")
end
if not bpev then
    Duel.LoadScript("util-bpev.lua")
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
    e2:SetCondition(function(e) return bcot.kanohi_con(e,{0x3b02}) end)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Place Nuva Symbol & allow direct attacks
    local e4,chainfilter=bpev.kanohi_nuva_search_trap(c,nil,s.operation4,id)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,chainfilter)
    e4:SetDescription(aux.Stringid(id,0))
    c:RegisterEffect(e4)
end
s.listed_series={0xb02,0x3b02,0xb04,0xb0c}
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(g) do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(3205)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetCode(EFFECT_DIRECT_ATTACK)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
        e2:SetCondition(s.condition4_1)
        e2:SetOperation(s.operation4_1)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
end
function s.condition4_1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttackTarget()==nil and e:GetHandler():IsHasEffect(EFFECT_DIRECT_ATTACK)
        and Duel.IsExistingMatchingCard(aux.NOT(Card.IsHasEffect),tp,0,LOCATION_MZONE,1,nil,EFFECT_IGNORE_BATTLE_TARGET)
end
function s.operation4_1(e,tp,eg,ep,ev,re,r,rp)
    -- The Wisdom of Cyberdark Edge: We have to properly handle the case of multiple stacked direct attack effects!
    -- In that case, list out the cards owning those effects and let the player choose.
    -- Our debuff is only applied if this effect is actually the chosen one.
    -- Caveats:
    --- 1) Most direct attack effects don't bother with this at all and just skip their drawbacks if they're mixed
    --- 2) If mixed with Cyberdark Edge, you will get 2 prompts and end up with anything from x1 to x1/4 ATK
    -- In a perfect world, all direct attack effects would communicate via some label or flag ...
    -- https://www.youtube.com/watch?v=Kl3H4vMqYNo
    local c=e:GetHandler()
    local effs={c:GetCardEffect(EFFECT_DIRECT_ATTACK)}
    local eg=Group.CreateGroup()
    for _,eff in ipairs(effs) do
        eg:AddCard(eff:GetOwner())
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
    local ec=#eg==1 and eg:GetFirst() or eg:Select(tp,1,1,nil):GetFirst()
    if ec==e:GetOwner() then
        local e1=Effect.CreateEffect(e:GetOwner())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(c:GetAttack()/2)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_DAMAGE_CAL)
        c:RegisterEffect(e1)
    end
end
