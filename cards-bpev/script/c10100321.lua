if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Nuva Symbol of Granite Tenacity
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Search EP or Pohatu
    local e1=bpev.nuva_symbol_search(c,10100004,aux.Stringid(id,3))
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(s.condition2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
    --Leave field
    local e3=bpev.nuva_symbol_punish(c,s.operation3)
    e3:SetDescription(aux.Stringid(id,2))
    c:RegisterEffect(e3)
end
function s.filter2a(c)
    return c:IsFaceup() and c:IsSetCard(0x3b02)
end
function s.filter2b(c,e,tp)
    return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_MZONE,0,1,nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter2b),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
   end
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2b),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local tc=Duel.GetFirstTarget() --Neat, we still get it
    local rg=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_MZONE,0,1,1,tc)
    if #rg>0 then
        Duel.Release(rg,REASON_EFFECT)
    end
end

