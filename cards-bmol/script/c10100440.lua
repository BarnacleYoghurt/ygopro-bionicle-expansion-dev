Duel.LoadScript("util-bmol.lua")
--Makuta-Spawned Kraata
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Quick Healing
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
function s.filter1a(c,e,tp)
    return c:IsFaceup() and (not (c:IsSetCard(SET_MAKUTA) and c:IsLevelAbove(2))
            or Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,e,tp)
        )
end
function s.filter1b(c,e,tp)
    return c:IsSetCard(SET_KRAATA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.filter1c(c)
    return c:IsFaceup() and c:HasLevel()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter1a(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc:IsSetCard(SET_MAKUTA) and tc:IsLevelAbove(2) then
        e:SetLabel(1)
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,tp)
    else
        e:SetLabel(2)
        e:SetCategory(0)
    end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local op=e:GetLabel()
    if op==1 then
        if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:UpdateLevel(-1,0,c)==-1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp)
            if #sg>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
        end
    elseif op==2 then
        if tc:IsRelateToEffect(e) and tc:IsFaceup() then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(0)
            e1:SetReset(RESETS_STANDARD_PHASE_END)
            tc:RegisterEffect(e1)
        end
        local lg=Duel.GetMatchingGroup(s.filter1c,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
        for lc in lg:Iter() do
            lc:UpdateLevel(1,0,c)
        end
    end
end
function s.filter2(c,tp)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND) and c:IsAbleToDeck()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,3,nil) and c:IsSSetable()
    end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,3,nil) then return end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,3,3,nil)
    if Duel.SendtoDeck(g,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)==3
    and c:IsRelateToEffect(e) and c:IsSSetable() then
        Duel.SSet(tp,c)
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(3300)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetValue(LOCATION_REMOVED)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        c:RegisterEffect(e1)
    end
end
