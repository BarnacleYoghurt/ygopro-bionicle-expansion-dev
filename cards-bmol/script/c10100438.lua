Duel.LoadScript("util-bmol.lua")
--Kraata Stasis Breach
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Increase Levels
    local e1a=Effect.CreateEffect(c)
    e1a:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1a:SetCode(EVENT_CHAINING)
    e1a:SetRange(LOCATION_FZONE)
    e1a:SetOperation(aux.chainreg)
    c:RegisterEffect(e1a)
    local e1b=Effect.CreateEffect(c)
    e1b:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
    e1b:SetProperty(EFFECT_FLAG_DELAY)
    e1b:SetRange(LOCATION_FZONE)
    e1b:SetCode(EVENT_CHAIN_SOLVED)
    e1b:SetCondition(function(e) return e:GetHandler():HasFlagEffect(1) end)
    e1b:SetOperation(s.operation1)
    c:RegisterEffect(e1b)
    --Add to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SEARCH|CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCondition(s.condition2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
    local e2b=e2:Clone()
    e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2b)
    --Special Summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1,{id,1})
    c:RegisterEffect(e3)
end
function s.filter1(c)
    return c:IsFaceup() and c:IsSetCard(SET_KRAATA) and c:HasLevel()
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    if re:IsMonsterEffect() and rp==tp and re:GetHandler():IsSetCard(SET_KRAATA) then
        local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_MZONE,0,nil)
        g:ForEach(Card.UpdateLevel,1,RESET_EVENT|RESETS_STANDARD,e:GetHandler())
    end
end
function s.filter2a(c,tp)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND) and c:IsControler(tp)
end
function s.filter2b(c,tp)
    return c:IsSetCard(SET_KRAATA) and c:IsMonster() and c:IsAbleToHand()
        and not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,c:GetCode()),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.filter2a,1,nil,tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2b),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,tp)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function s.filter3(c,e,tp)
    return c:IsSetCard(SET_KRAATA) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,tp,tp,false,false)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter3(chkc,e,tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE|LOCATION_REMOVED) end
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,nil,e,tp)
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
    end
end