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
    local params={handler=c,fusfilter=aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),matfilter=Fusion.OnFieldMat,
                  extrafil=s.extrafil,extratg=s.extratg,extraop=s.extraop,stage2=s.stage2}
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(Fusion.SummonEffTG(params))
    e2:SetOperation(Fusion.SummonEffOP(params))
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
function s.checkmat(tp,sg,fc)
    return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE|LOCATION_REMOVED)<=1
end
function s.extrafil(e,tp,mg)
    if e:GetHandler():IsFusionSummoned() then
        local eg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Fusion.IsMonsterFilter(Card.IsAbleToDeck)),tp,LOCATION_GRAVE,0,nil)
              +  Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_REMOVED,0,nil)
        return eg,s.checkmat
    end
    return nil
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE|LOCATION_REMOVED)
end
function s.extraop(e,tc,tp,sg)
    local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE|LOCATION_REMOVED)
    if #rg>0 then
        sg:Sub(rg)
        Fusion.ShuffleMaterial(e,tc,tp,rg)
    end
end
function s.stage2(e,tc,tp,sg,chk)
    if chk==0 then
        local fg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_MZONE)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(fg:GetSum(Card.GetPreviousLevelOnField)*100)
        e1:SetReset(RESET_EVENT|RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end