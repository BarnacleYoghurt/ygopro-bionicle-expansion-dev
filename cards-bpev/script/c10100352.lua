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
function s.filter1(c)
    return c:IsFaceup() and (c:IsAttack(0) or c:IsDefense(0))
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsFaceup() and chkc:IsSetCard(0xb06) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then
        return Duel.IsExistingTarget(aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_MZONE,0,1,nil)
            and Duel.IsExistingMatchingCard(Card.IsFaceup,1-tp,LOCATION_MZONE,0,1,nil)
    end
    local max=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_MZONE,0,1,max,nil)
    Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetTargetCards(e):Filter(aux.FaceupFilter(Card.IsControler,tp),nil)
    local og=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
    if #tg>0 and #og>0 then
        local val=tg:GetSum(Card.GetAttack)
        for tc in og:Iter() do
            tc:UpdateAttack(-math.min(val,tc:GetAttack()),RESET_EVENT+RESETS_STANDARD,e:GetHandler())
            tc:UpdateDefense(-math.min(val,tc:GetDefense()),RESET_EVENT+RESETS_STANDARD,e:GetHandler())
            --Hack: highlight any who hit 0 so player can tell before ATK/DEF is redrawn
            if s.filter1(tc) then Duel.HintSelection(tc,true) end
        end
        if og:IsExists(s.filter1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            local dg=og:FilterSelect(tp,s.filter1,1,1,nil)
            if #dg>0 then
                Duel.BreakEffect()
                Duel.Destroy(dg,REASON_EFFECT)
            end
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
        local tc=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
        if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(0)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1,true)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
            tc:RegisterEffect(e2,true)
        end
        Duel.SpecialSummonComplete()
    end
end