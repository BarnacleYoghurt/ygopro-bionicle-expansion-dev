Duel.LoadScript("util-bmol.lua")
--Lerahk, Poison Rahkshi
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Material
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,10100436,s.filter0)
    --Negate
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetCondition(s.condition2)
    e2:SetOperation(s.operation2)
    c:RegisterEffect(e2)
end
function s.filter0(c,fc,sumtype,tp)
    return c:IsRace(RACE_FIEND,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp)
        and c:GetLevel()>=4
end
function s.condition2(e)
    local c=Duel.GetBattleMonster(e:GetHandlerPlayer())
    local tc=c:GetBattleTarget()
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)
       and tc and tc:IsRelateToBattle()
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
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