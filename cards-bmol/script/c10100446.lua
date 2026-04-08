Duel.LoadScript("util-bmol.lua")
--Lerahk, Poison Rahkshi
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Material
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,10100436,s.filter0)
    --Send to GY
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(function (e) return e:GetHandler():IsFusionSummoned() end)
    e1:SetCost(s.cost1)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
    --Negate
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetTarget(s.target2)
    c:RegisterEffect(e2)
    --Force adjust so negation applies at attack declaration (see: Scareclaw Kashtira)
    local e2b=Effect.CreateEffect(c)
    e2b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2b:SetCode(EVENT_BE_BATTLE_TARGET)
    e2b:SetRange(LOCATION_MZONE)
    e2b:SetOperation(function(e) Duel.AdjustInstantly(e:GetHandler()) end)
    c:RegisterEffect(e2b)
end
function s.filter0(c,fc,sumtype,tp)
    return c:IsRace(RACE_FIEND,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp)
        and c:GetLevel()>=4
end
function s.filter1(c)
    return c:IsSetCard(SET_KRAATA) and c:IsMonster() and c:IsAbleToGraveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local e1a=Effect.CreateEffect(e:GetHandler())
    e1a:SetType(EFFECT_TYPE_FIELD)
    e1a:SetTargetRange(0,LOCATION_MZONE)
    e1a:SetCode(EFFECT_UPDATE_ATTACK)
    e1a:SetValue(-600)
    e1a:SetReset(RESET_PHASE|PHASE_END,2)
    Duel.RegisterEffect(e1a,tp)
    local e1b=e1a:Clone()
    e1b:SetCode(EFFECT_UPDATE_DEFENSE)
    Duel.RegisterEffect(e1b,tp)
end
function s.target2(e,c)
    local fid=e:GetHandler():GetFieldID()
    for _,label in ipairs({c:GetFlagEffectLabel(id)}) do
        if fid==label then return true end
    end
    local bc=c:GetBattleTarget()
    if c:IsRelateToBattle() and bc and bc:IsControler(e:GetHandlerPlayer())
    and bc:IsFaceup() and bc:IsAttribute(ATTRIBUTE_DARK) and bc:IsRace(RACE_FIEND) then
        c:RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1,fid)
        return true
    end
    return false
end