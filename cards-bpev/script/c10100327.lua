if not bcot then
    Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Aki Nuva
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c)
    --Destroy if replaced
    local e1=bcot.kanohi_selfdestruct(c)
    c:RegisterEffect(e1)
    --Indestructible by battle
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetCondition(s.condition)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --ATK gain
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetCondition(s.condition)
    e3:SetValue(1000)
    c:RegisterEffect(e3)
    --Piercing
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_PIERCE)
    e4:SetCondition(s.condition)
    c:RegisterEffect(e4)
    --Attack All
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_ATTACK_ALL)
    e5:SetCondition(s.condition)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    --Change Level and name
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,0))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetRange(LOCATION_SZONE)
    e6:SetTarget(s.target6)
    e6:SetOperation(s.operation6)
    c:RegisterEffect(e6)
end
s.listed_series={0xb02,0x3b02,0xb04}
function s.condition(e)
    return bcot.kanohi_con(e,{0x3b02}) and e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ)
end
function s.filter6a(c,tp)
    return c:IsSetCard(0xb02) and c:HasLevel() and not c:IsPublic()
        and Duel.IsExistingTarget(s.filter6b,tp,LOCATION_MZONE,0,1,nil,c:GetLevel(),c:GetCode())
end
function s.filter6b(c,lv,code)
    return c:IsFaceup() and c:HasLevel() and not (c:IsLevel(lv) and c:IsCode(code))
end
function s.target6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter6b(chkc,e:GetLabel()) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter6a,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local rc=Duel.SelectMatchingCard(tp,s.filter6a,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
    Duel.ConfirmCards(1-tp,rc)
    e:SetLabel(rc:GetLevel(),rc:GetCode())
    if rc:IsLocation(LOCATION_DECK) then
        Duel.ShuffleDeck(tp)
    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,s.filter6b,tp,LOCATION_MZONE,0,1,1,nil,e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.operation6(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local lv,code=e:GetLabel()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(lv)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CHANGE_CODE)
        e2:SetValue(code)
        tc:RegisterEffect(e2)
        Duel.BreakEffect()
        Duel.Destroy(c,REASON_EFFECT)
    end
end
