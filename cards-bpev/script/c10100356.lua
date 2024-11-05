--Exo Autonomy
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)
    --Search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCondition(s.condition2)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1)
    c:RegisterEffect(e2)
end
function s.filter1(c,e,tp)
    return c:IsCode(10100250) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        local tc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
        if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
            --Cannot activate
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(3302)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetCode(EFFECT_CANNOT_TRIGGER)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            --Destroy in End Phase
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e2:SetRange(LOCATION_MZONE)
            e2:SetCode(EVENT_PHASE+PHASE_END)
            e2:SetCondition(s.condition1_1)
            e2:SetOperation(s.operation1_1)
            e2:SetLabelObject(tc)
            e2:SetCountLimit(1)
            Duel.RegisterEffect(e2,tp)
            tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,1)
        end
        Duel.SpecialSummonComplete()
    end
end
function s.condition1_1(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffect(id)==0 then
        e:Reset()
        return false
    end
    return true
end
function s.operation1_1(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.Destroy(tc,REASON_EFFECT)
end
function s.filter2a(c)
    return c:IsSetCard(0xb02) and c:IsMonster() and c:IsAbleToHand()
end
function s.filter2b(c)
    return c:IsCode(10100251) and c:IsSSetable() and not (c:IsLocation(LOCATION_REMOVED) and c:IsFacedown())
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetTurnID()==Duel.GetTurnCount()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_DECK,0,1,1,nil)
    if #g1>0 then
        if Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 then
            Duel.ConfirmCards(1-tp,g1)
            local loc=LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED
            if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter2b),tp,loc,0,1,nil)
            and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
                local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2b),tp,loc,0,1,1,nil)
                if #g2>0 then
                    Duel.SSet(tp,g2)
                end
            end
        end
    end
end