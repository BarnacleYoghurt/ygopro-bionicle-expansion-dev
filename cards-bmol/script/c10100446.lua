Duel.LoadScript("util-bmol.lua")
--Lerahk, Poison Rahkshi
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Material
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,10100436,s.filter0)
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
    --Negate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetCondition(s.condition3)
    e3:SetOperation(s.operation3)
    c:RegisterEffect(e3)
end
function s.filter0(c,fc,sumtype,tp)
    return c:IsRace(RACE_FIEND,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp)
        and c:GetLevel()>=4
end
function s.value1(e,c)
    local g=e:GetHandler():GetMaterial():Filter(Card.IsCode,nil,10100436)
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
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
    if tc and Duel.Destroy(tc,REASON_EFFECT)>0 and tc:IsPreviousLocation(LOCATION_MZONE) and tc:GetTextAttack()>0 then
        Duel.Damage(1-tp,tc:GetTextAttack(),REASON_EFFECT)
    end
end
function s.condition3(e)
    local c=Duel.GetBattleMonster(e:GetHandlerPlayer())
    local tc=c:GetBattleTarget()
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)
       and tc and tc:IsRelateToBattle()
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetBattleMonster(1-tp)
    if tc:IsRelateToBattle() then
        local e1=Effect.CreateEffect(e:GetHandler())
    	e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetCondition(function () return Duel.IsPhase(PHASE_DAMAGE_CAL) and Duel.GetAttackTarget() end)
        e1:SetValue(-1200)
        e1:SetReset(RESET_PHASE|PHASE_DAMAGE_CAL)
        tc:RegisterEffect(e1)
        tc:NegateEffects(e:GetHandler(),RESET_PHASE|PHASE_END)
    end
end