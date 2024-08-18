if not bcor then
	Duel.LoadScript("util-bcor.lua")
end
--MKT Fish, Biting Rahi
local s,id=GetID()
function s.initial_effect(c)
    --Non-Tuner
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
    c:RegisterEffect(e1)
    --Synchro Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(s.condition2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetHintTiming(TIMING_MAIN_END)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
function s.filter2(c,rc,mg)
    return c:IsSynchroSummonable(rc,mg)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsTurnPlayer(1-tp) and Duel.IsMainPhase()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local mg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsRace,RACE_FISH|RACE_SEASERPENT|RACE_AQUA),tp,LOCATION_MZONE,0,nil)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,c,mg) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local mg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsRace,RACE_FISH|RACE_SEASERPENT|RACE_AQUA),tp,LOCATION_MZONE,0,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,c,mg)
        if #g>0 then
            Duel.SynchroSummon(tp,g:GetFirst(),c,mg)
        end
    end
end
