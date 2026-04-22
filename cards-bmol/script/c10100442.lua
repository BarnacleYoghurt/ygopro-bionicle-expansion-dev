Duel.LoadScript("util-bmol.lua")
--Guurahk, Disintegration Rahkshi
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Material
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,10100432,s.filter0)
    --Disintegrate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(aux.StatChangeDamageStepCondition)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
function s.filter0(c,fc,sumtype,tp)
    return c:IsRace(RACE_FIEND,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp)
        and c:GetLevel()>=4
end
function s.filter1(c)
    return c:IsFaceup() and not (c:GetAttack()>0 or c:GetDefense()>0)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
    local lost=false
    if #g>0 then
        for tc in g:Iter() do
            local atk=tc:GetAttack()
            local def=tc:GetDefense()
            lost=(tc:UpdateAttack(-1200,RESET_EVENT|RESETS_STANDARD,e:GetHandler())~=0) or lost
            lost=(tc:UpdateDefense(-1200,RESET_EVENT|RESETS_STANDARD,e:GetHandler())~=0) or lost
        end
    end
    local gg=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_MZONE,nil)
    if lost and #gg>0 then
        Duel.BreakEffect()
        Duel.SendtoGrave(gg,REASON_EFFECT)
    end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(Card.IsNegatableSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if chk==0 then return #g>0 end
    Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,g,#g,tp,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsNegatableSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if #g>0 then
        for tc in g:Iter() do
            tc:NegateEffects(e:GetHandler(),RESET_PHASE|PHASE_END,true)
        end
    end
end