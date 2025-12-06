Duel.LoadScript("util-bmol.lua")
--Washed and Chilled
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)
end
s.listed_names={CARD_AVOHKII}
function s.filter1a(c)
    return c:IsMonster() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable()
end
function s.filter1b(c)
    return c:IsCode(CARD_AVOHKII) and not c:IsPublic()
end
function s.filter1c(c,e,tp)
    return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAbleToRemove),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,0)
    Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_REMOVED)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local rg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAbleToRemove),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if #rg>0 then
        aux.RemoveUntil(rg,nil,REASON_EFFECT,PHASE_END,id,e,tp,aux.DefaultFieldReturnOp)

        local b1=Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_HAND,0, 1,nil)
        local b2=Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_HAND,0, 1,nil)
        if rg:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) and (b1 or b2)
            and Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_REMOVED,0,1,nil,e,tp)
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
            local op=Duel.SelectEffect(tp,
                {b1,aux.Stringid(id,0)},
                {b2,aux.Stringid(id,1)},
                {true,aux.Stringid(id,2)})
            if op==1 then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
                Duel.DiscardHand(tp,s.filter1a,1,1,REASON_EFFECT|REASON_DISCARD)
            elseif op==2 then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
                local cg=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_HAND,0,1,1,nil)
                Duel.ConfirmCards(1-tp,cg)
            end

            if op==1 or op==2 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local sg=Duel.SelectMatchingCard(tp,s.filter1c,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
                if #sg>0 then
                    Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end