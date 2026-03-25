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
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetTarget(s.target3)
    c:RegisterEffect(e3)
    --Force adjust so negation applies at attack declaration (see: Scareclaw Kashtira)
    --Note: also lasts after the damage step until the next attack is declared, but that's a GetBattleTarget issue
    local e3b=Effect.CreateEffect(c)
    e3b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3b:SetCode(EVENT_BE_BATTLE_TARGET)
    e3b:SetRange(LOCATION_MZONE)
    e3b:SetOperation(function(e) Duel.AdjustInstantly(e:GetHandler()) end)
    c:RegisterEffect(e3b)
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
function s.target3(e,c)
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and c:IsAttackBelow(e:GetHandler():GetLevel()*600)
       and bc and bc:IsControler(e:GetHandlerPlayer()) and bc:IsFaceup()
       and bc:IsAttribute(ATTRIBUTE_DARK) and bc:IsRace(RACE_FIEND)
end