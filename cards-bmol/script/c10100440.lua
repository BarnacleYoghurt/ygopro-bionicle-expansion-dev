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
    --Protection
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTarget(s.target2)
    e2:SetValue(s.value2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
function s.filter1a(c,e,tp)
    return c:IsFaceup() and (not c:IsSetCard(SET_MAKUTA)
            or (c:IsLevelAbove(2) and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,e,tp))
        )
end
function s.filter1b(c,e,tp)
    return c:IsSetCard(SET_KRAATA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.filter1c(c)
    return c:IsFaceup() and c:HasLevel() and c:IsSetCard(SET_KRAATA)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter1a(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc:IsSetCard(SET_MAKUTA) then
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
            tc:UpdateAttack(-1200,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,c)
        end
        local lg=Duel.GetMatchingGroup(s.filter1c,tp,LOCATION_MZONE,0,nil)
        for lc in lg:Iter() do
            lc:UpdateLevel(1,0,c)
        end
    end
end
function s.filter2(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
       and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)
       and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetFlagEffect(tp,id)==0 and e:GetHandler():IsAbleToRemove()
           and eg:IsExists(s.filter2,1,nil,tp)
    end
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
        Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
        return true
    else
        return false
    end
end
function s.value2(e,c)
    return s.filter2(c,e:GetHandlerPlayer())
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
