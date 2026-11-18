Duel.LoadScript("util-bmol.lua")
--Kolhii Field
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
    --Add to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
function s.filter1a(c,tp)
    return c:IsSetCard(SET_KORO) and c:IsFieldSpell() and not c:IsForbidden() and c:CheckUniqueOnField(tp)
       and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c.listed_attributes)
end
function s.filter1b(c,attr)
    if c:IsFaceup() and attr then
        for _,a in ipairs(attr) do
            if c:IsAttribute(a) then return true end
        end
    end
    return false
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter1a),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,tp) and
       Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1a),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,tp)
        if #g>0 then
            Duel.PlaceFieldSpell(g:GetFirst(),tp)
        end
    end
end
function s.filter2(c,fc)
    if c:IsSetCard(SET_MATORAN) and c:IsAbleToHand() and fc.listed_attributes then
        for _,a in ipairs(fc.listed_attributes) do
            if c:IsAttribute(a) then return true end
        end
    end
    return false
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local fc=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsSetCard,SET_KORO),tp,LOCATION_FZONE,0,nil):GetFirst()
    if chk==0 then return fc and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,fc) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local fc=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsSetCard,SET_KORO),tp,LOCATION_FZONE,0,nil):GetFirst()
    if fc then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local ac=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,fc):GetFirst()
        if ac and Duel.SendtoHand(ac,tp,REASON_EFFECT)>0 and ac:IsLocation(LOCATION_HAND) then
            Duel.ConfirmCards(tp,ac)

            -- Cannot Special Summon, except Warriors and/or added Attribute
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(id,2))
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
            e1:SetTargetRange(1,0)
            e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
            e1:SetTarget(function(e,c) return not (c:IsRace(RACE_WARRIOR) or c:IsAttribute(ac:GetAttribute())) end)
            e1:SetReset(RESET_PHASE|PHASE_END)
            Duel.RegisterEffect(e1,tp)
        end
    end
end