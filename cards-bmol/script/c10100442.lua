Duel.LoadScript("util-bmol.lua")
--Guurahk, Disintegration Rahkshi
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Material
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,10100432,s.filter0)
    --ATK
    local e1a=Effect.CreateEffect(c)
    e1a:SetType(EFFECT_TYPE_SINGLE)
    e1a:SetCode(EFFECT_MATERIAL_CHECK)
    e1a:SetValue(s.value1)
    c:RegisterEffect(e1a)
    local e1b=Effect.CreateEffect(c)
    e1b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1b:SetCondition(s.condition1)
    e1b:SetOperation(s.operation1)
    e1b:SetLabelObject(e1a)
    c:RegisterEffect(e1b)
    --Disintegrate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(aux.StatChangeDamageStepCondition)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetHintTiming(TIMING_DAMAGE_STEP)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
    --Negate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1,id)
    c:RegisterEffect(e3)
end
function s.filter0(c,fc,sumtype,tp)
    return c:IsRace(RACE_FIEND,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp)
        and c:GetLevel()>=4
end
function s.value1(e,c)
    local g=e:GetHandler():GetMaterial():Filter(Card.IsCode,nil,10100432)
    e:SetLabel(g:GetSum(Card.GetLevel))
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFusionSummoned()
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --Increase ATK
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(e:GetLabelObject():GetLabel()*600)
    e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
    e:GetHandler():RegisterEffect(e1)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
    for tc in g:Iter() do
        local atk=tc:GetAttack()
        local def=tc:GetDefense()
        tc:UpdateAttack(-1000,RESET_EVENT|RESETS_STANDARD,e:GetHandler())
        tc:UpdateDefense(-1000,RESET_EVENT|RESETS_STANDARD,e:GetHandler())
        if (atk>0 and tc:GetAttack()==0) or (def>0 and tc:GetDefense()==0) then
            Duel.Destroy(tc,REASON_EFFECT)
        end
    end
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(Card.IsNegatableSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if chk==0 then return #g>0 end
    Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,g,#g,tp,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsNegatableSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if #g>0 then
        for tc in g:Iter() do
            tc:NegateEffects(e:GetHandler(),RESET_PHASE|PHASE_END,true)
        end
    end
end