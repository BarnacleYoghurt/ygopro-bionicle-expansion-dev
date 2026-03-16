Duel.LoadScript("util-bmol.lua")
--Toxic Kraata Ye
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Cannot be destroyed by battle
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Negate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetCondition(s.condition3)
    e3:SetOperation(s.operation3)
    c:RegisterEffect(e3)
end
function s.filter1(c)
    return c:IsFaceup() and c:HasLevel() and c:IsSetCard(SET_KRAATA)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_KRAATA),tp,LOCATION_MZONE,0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,tp,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
            and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.BreakEffect()
            local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_MZONE,0,nil)
            for tc in g:Iter() do
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                --apparently needed when also affecting self, so can't use tc:UpdateLevel
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetCode(EFFECT_UPDATE_LEVEL)
                e1:SetValue(1)
                e1:SetReset(RESET_EVENT|RESETS_STANDARD)
                tc:RegisterEffect(e1)
            end
        end
    end
end
function s.condition3(e)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    return tc and tc:IsRelateToBattle() and tc:IsAttackBelow(600*c:GetLevel())
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    if tc:IsRelateToBattle() then
        tc:NegateEffects(e:GetHandler(),RESET_PHASE|PHASE_END)
    end
end