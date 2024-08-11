--Rahi from the Depths
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then
        return Duel.IsExistingTarget(aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_MZONE,0,1,nil)
            and Duel.IsExistingTarget(Card.IsFaceup,1-tp,LOCATION_MZONE,0,1,nil)
    end
    local max=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g1=Duel.SelectTarget(tp,aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_MZONE,0,1,max,nil)
    local g2=Duel.SelectTarget(tp,Card.IsFaceup,1-tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local g1,g2=Duel.GetTargetCards(e):Filter(Card.IsFaceup,nil):Split(Card.IsControler,nil,tp)
    if #g1>0 and #g2>0 then
        local tc=g2:GetFirst()
        local val=g1:GetSum(Card.GetAttack)
        tc:UpdateAttack(-math.min(val,tc:GetAttack()),RESET_EVENT+RESETS_STANDARD,e:GetHandler())
        tc:UpdateDefense(-math.min(val,tc:GetDefense()),RESET_EVENT+RESETS_STANDARD,e:GetHandler())
        Duel.Readjust()
        if (tc:IsAttack(0) or tc:IsDefense(0)) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.BreakEffect()
            Duel.Destroy(tc,REASON_EFFECT)
        end
    end
end
function s.filter2(c,e,tp)
    return c:IsRace(RACE_FISH|RACE_SEASERPENT|RACE_AQUA) and c:IsSetCard(0xb06)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end