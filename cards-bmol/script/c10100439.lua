Duel.LoadScript("util-bmol.lua")
--Rahkshi Armor
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Material
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_EP),aux.FilterBoolFunctionEx(Card.IsSetCard,SET_KRAATA))
    --Must be either Fusion Summoned ...
    local e1a=Effect.CreateEffect(c)
    e1a:SetType(EFFECT_TYPE_SINGLE)
    e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1a:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1a:SetValue(aux.fuslimit)
    c:RegisterEffect(e1a)
    --or Special Summoned by ...
    local e1b=Effect.CreateEffect(c)
    e1b:SetType(EFFECT_TYPE_FIELD)
    e1b:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1b:SetCode(EFFECT_SPSUMMON_PROC)
    e1b:SetRange(LOCATION_EXTRA)
    e1b:SetCondition(s.condition1)
    e1b:SetTarget(s.target1)
    e1b:SetOperation(s.operation1)
    c:RegisterEffect(e1b)
    --Fusion Summon
    local params={handler=c,matfilter=Fusion.OnFieldMat,extrafil=s.filter3}
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(Fusion.SummonEffTG(params))
    e2:SetOperation(Fusion.SummonEffOP(params))
    e2:SetHintTiming(0,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
    e2:SetCountLimit(1)
    c:RegisterEffect(e2)
end
s.material_setcode={SET_EP,SET_KRAATA}
function s.filter1(c,tp,sc)
    return c:IsSetCard(SET_KRAATA) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.condition1(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.CheckReleaseGroup(tp,s.filter1,1,false,1,false,c,tp,nil,false,nil,tp,c)
       and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_KRAATA),tp,LOCATION_MZONE,0,2,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local g=Duel.SelectReleaseGroup(c:GetControler(),s.filter1,1,1,false,true,false,c,tp,nil,false,nil,tp,c)
    if g then
        g:KeepAlive()
        e:SetLabelObject(g)
        return true
    else
        return false
    end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    Duel.Release(g,REASON_COST|REASON_MATERIAL)
    c:SetMaterial(g)
    g:DeleteGroup()
end
function s.filter3(e,tp,mg)
    if e:GetHandler():IsFusionSummoned() then
        return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToGrave),tp,LOCATION_HAND,0,nil)
    end
    return nil
end
