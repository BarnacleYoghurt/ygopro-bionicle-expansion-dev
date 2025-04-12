if not bcot then
    Duel.LoadScript("util-bcot.lua")
end
--Legendary Kanohi Vahi, Mask of Time
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c)
    --Only 1 "Vahi" Equip Spell
    c:SetUniqueOnField(1,0,s.filter0,LOCATION_SZONE)
    --Destroy if replaced
    local e1=bcot.kanohi_selfdestruct(c)
    c:RegisterEffect(e1)
    --Cannot attack
    local e2a=Effect.CreateEffect(c)
    e2a:SetType(EFFECT_TYPE_EQUIP)
    e2a:SetCode(EFFECT_CANNOT_ATTACK)
    c:RegisterEffect(e2a)
    --Cannot activate
    local e2b=e2a:Clone()
    e2b:SetCode(EFFECT_CANNOT_TRIGGER)
    c:RegisterEffect(e2b)
    --Cannot target
    local e2c=e2a:Clone()
    e2c:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2c:SetValue(aux.tgoval)
    c:RegisterEffect(e2c)
    --To hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(s.condition3)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1)
    c:RegisterEffect(e3)
end
s.listed_series={0xb02,0xb04,0xb07,0xb0d}
function s.filter0(c)
    return c:IsSetCard(0xb0d) and c:IsEquipSpell()
end
function s.filter3(c)
    return c:IsSetCard(0xb0d) and not c:IsEquipSpell() and c:IsAbleToHand()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    return ec and ec:IsControler(e:GetOwnerPlayer())
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter3),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end