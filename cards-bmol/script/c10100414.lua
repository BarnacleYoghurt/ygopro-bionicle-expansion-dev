Duel.LoadScript("util-bmol.lua")
--Matoran Shipwright Marka
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon self
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Special Summon from Deck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCost(s.cost2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            local mc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
            if mc then
                Duel.BreakEffect()
                local opp=mc:GetControler()~=tp
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
                local zone=Duel.SelectDisableField(tp,1,
                    opp and 0 or LOCATION_MZONE,
                    opp and LOCATION_MZONE or 0,0)
                if opp then zone=zone>>16 end
                Duel.MoveSequence(mc,math.log(zone,2))
            end
        end
    end
end
function s.filter2a(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable()
end
function s.filter2b(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(SET_MATORAN)
       and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,s.filter2a,1,1,REASON_COST|REASON_DISCARD)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
           and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_DECK,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
        aux.DelayedOperation(g,PHASE_END,id,e,tp,
            function(ag) Duel.SendtoHand(ag,nil,REASON_EFFECT) end,
			nil,0,0,aux.Stringid(id,3)
		)
    end
end