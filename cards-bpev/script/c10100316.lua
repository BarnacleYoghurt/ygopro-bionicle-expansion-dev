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
    local e4,chainfilter=bpev.kanohi_nuva_search_trap(c,s.target4,s.operation4,id)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,chainfilter)
    e4:SetDescription(aux.Stringid(id,0))
    c:RegisterEffect(e4)
end
s.listed_series={0xb02,0x3b02,0xb04,0xb0c}
function s.condition2(e)
    local ec=e:GetHandler():GetEquipTarget()
    return bcot.kanohi_con(e,{0x3b02}) and ec:IsControler(e:GetOwnerPlayer())
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        local tc=g:RandomSelect(tp,1):GetFirst()
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
        tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetLabelObject(tc)
        e1:SetCondition(s.condition4_1)
        e1:SetOperation(s.operation4_1)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function s.condition4_1(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabelObject():GetFlagEffect(id)==0 then
        e:Reset()
        return false
    else
        return true
    end
end
function s.operation4_1(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoHand(e:GetLabelObject(),1-tp,REASON_EFFECT)
end