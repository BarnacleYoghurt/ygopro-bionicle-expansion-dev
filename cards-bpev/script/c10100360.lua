--Naming Day
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)
    --Rename
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(s.cost2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    c:RegisterEffect(e2)
end
function s.filter1a(c,e,tp)
    return c:IsRace(RACE_WARRIOR) and c:IsReleasableByEffect()
        and Duel.GetMZoneCount(tp,c)>0 and c:HasLevel()
        and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c,e,tp)
end
function s.filter1b(c,rc,e,tp)
    return c:IsRace(RACE_WARRIOR)
        and c:GetOriginalLevel()>rc:GetOriginalLevel()
        and c:GetOriginalLevel()-rc:GetOriginalLevel()<=2
        and c:IsOriginalAttribute(rc:GetOriginalAttribute())
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter1a(chkc,e,tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function s.filter2a(c,tp)
    return c:IsRace(RACE_WARRIOR) and c:IsAbleToRemoveAsCost()
        and Duel.IsExistingTarget(s.filter2b,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
function s.filter2b(c,code)
    return c:IsFaceup() and not c:IsCode(code)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_GRAVE,0,1,nil,tp) and c:IsAbleToRemoveAsCost() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rc=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
    e:SetLabel(rc:GetCode())
    Duel.Remove(Group.FromCards(rc,c),POS_FACEUP,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter2b(chkc,e:GetLabel()) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,s.filter2b,tp,LOCATION_MZONE,0,1,1,nil,e:GetLabel())
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e1)
    end
end
