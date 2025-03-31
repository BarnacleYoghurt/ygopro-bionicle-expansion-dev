if not bcot then
    Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Rua Nuva
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c)
    --Destroy if replaced
    local e1=bcot.kanohi_selfdestruct(c)
    c:RegisterEffect(e1)
    --Immune
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetCondition(s.condition)
    e2:SetValue(s.value2)
    c:RegisterEffect(e2)
    --Hand Reveal
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(0,LOCATION_HAND)
    e3:SetCode(EFFECT_PUBLIC)
    e3:SetCondition(s.condition)
    c:RegisterEffect(e3)
    --Search
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTarget(s.target4)
    e4:SetOperation(s.operation4)
    e4:SetCountLimit(1,id)
    c:RegisterEffect(e4)
end
s.listed_series={0xb02,0x3b02,0xb04,0xb0c}
function s.condition(e)
    return bcot.kanohi_con(e,{0x3b02}) and e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ)
end
function s.value2(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function s.filter4(c)
    return c:IsSetCard(0xb0c) and (c:IsNormalSpell() or c:IsQuickPlaySpell()) and c:IsAbleToHand()
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
        Duel.ConfirmCards(1-tp,g)
        Duel.BreakEffect()
        Duel.Destroy(e:GetHandler(),REASON_EFFECT)
    end
end