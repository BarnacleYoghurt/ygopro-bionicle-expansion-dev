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
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(function (e) return e:GetHandler():IsFusionSummoned() end)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
    --Negate
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
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
    return c:IsSetCard(SET_KRAATA) and c:IsMonster() and c:IsAbleToGrave()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil)
    if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetTargetRange(LOCATION_MZONE,0)
        e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
        e1:SetTarget(function (e,c) return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND) end)
        e1:SetValue(aux.tgoval)
        e1:SetReset(RESET_PHASE|PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
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