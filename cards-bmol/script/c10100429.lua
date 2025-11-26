Duel.LoadScript("util-bmol.lua")
--Graalok, Ash Bear Rahi
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon (Avohkii)
    local e1a=Effect.CreateEffect(c)
    e1a:SetDescription(aux.Stringid(id,0))
    e1a:SetCategory(CATEGORY_DESTROY|CATEGORY_SPECIAL_SUMMON)
    e1a:SetType(EFFECT_TYPE_QUICK_O)
    e1a:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1a:SetRange(LOCATION_HAND|LOCATION_GRAVE)
    e1a:SetCode(EVENT_FREE_CHAIN)
    e1a:SetCondition(function() return Duel.IsMainPhase() end)
    e1a:SetCost(s.cost1a)
    e1a:SetTarget(s.target1)
    e1a:SetOperation(s.operation1)
    e1a:SetHintTiming(TIMING_MAIN_END)
    e1a:SetCountLimit(1,id)
    c:RegisterEffect(e1a)
    --Special Summon (Rahi)
    local e1b=e1a:Clone()
    e1b:SetDescription(aux.Stringid(id,1))
    e1b:SetCost(s.cost1b)
    c:RegisterEffect(e1b)
    --To hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_DAMAGE_STEP_END)
    e2:SetCondition(s.condition2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    c:RegisterEffect(e2)
end
s.listed_names={CARD_AVOHKII}
function s.filter1a(c)
    return c:IsCode(CARD_AVOHKII) and not c:IsPublic()
end
function s.filter1b(c)
    return c:IsRace(RACE_BEAST|RACE_WINGEDBEAST) and c:IsSetCard(0xb06) and c:IsType(TYPE_PENDULUM)
end
function s.filter1c(c,tp)
    return c:IsFaceup() and Duel.GetMZoneCount(c:GetControler(),c,tp)>0
end
function s.cost1a(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.filter1a,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
end
function s.cost1b(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.filter1b,1,true,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectReleaseGroupCost(tp,s.filter1b,1,1,true,nil)
    Duel.Release(g,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter1c(chkc,tp) and chkc:IsLocation(LOCATION_ONFIELD) end
    local c=e:GetHandler()
    if chk==0 then
        return Duel.IsExistingTarget(s.filter1c,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)
            and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,s.filter1c,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local p=tc:GetControler()
        if Duel.Destroy(tc,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(p,LOCATION_MZONE)>0 then
            if Duel.SpecialSummonStep(c,0,tp,p,false,false,POS_FACEUP_ATTACK) and c:IsPreviousLocation(LOCATION_GRAVE) then
                local e1=Effect.CreateEffect(c)
                e1:SetDescription(3301)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT)
                e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
                e1:SetValue(LOCATION_DECKBOT)
                e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
                c:RegisterEffect(e1)
            end
            Duel.SpecialSummonComplete()
        end
    end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp,chk)
    return e:GetHandler():IsRelateToBattle()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end