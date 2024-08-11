--Rahi Nui, Vengeful Chimera
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Material
    Fusion.AddProcMixRep(c,true,true,s.filter0a,3,99)
    Fusion.AddContactProc(c,s.contactfil,s.contactop,aux.fuslimit)
    c:EnableReviveLimit()
    --Copy Types
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
    --Special Summon
    local e2a=Effect.CreateEffect(c)
    e2a:SetDescription(aux.Stringid(id,0))
    e2a:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2a:SetProperty(EFFECT_FLAG_DELAY)
    e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2a:SetTarget(s.target2)
    e2a:SetOperation(s.operation2)
    e2a:SetCountLimit(1,id)
    c:RegisterEffect(e2a)
    local e2b=e2a:Clone()
    e2b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2b:SetRange(LOCATION_MZONE)
    e2b:SetCondition(s.condition2b)
    c:RegisterEffect(e2b)
end
function s.filter0a(c,fc,sumtype,tp,sub,mg,sg,contact)
    if sg and #sg==0 then
        --Okay, so there's some weirdness going on here
        --sg holds the selection after picking the first material, but then becomes empty
        --at the same time, mg seemingly goes from holding possible material to holding the selection!
        --Also this has some real performance issues on big selections ...
        sg=mg
    end
    return c:IsSetCard(0xb06,fc,sumtype,tp) and not (sg and sg:IsExists(s.filter0b,1,c,fc,sumtype,tp,c:GetCode(fc,sumtype,tp)))
        and (not contact or not sg or sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK,fc,sumtype,tp))
end
function s.filter0b(c,fc,sumtype,tp,code)
    return c:IsSummonCode(fc,sumtype,tp,code) and not c:IsHasEffect(511002961)
end
function s.contactfil(tp)
    return Duel.GetReleaseGroup(tp)
end
function s.contactop(g)
    Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local race=0
    for tc in g:Iter() do
        race=race|tc:GetOriginalRace()
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ADD_RACE)
    e1:SetValue(race)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
    c:RegisterEffect(e1)
end
function s.filter2(c,e,tp,race)
    return c:IsLevelBelow(10) and c:IsSetCard(0xb06) and c:IsRace(race)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetRace()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        if c:IsFaceup() then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler():GetRace())
            if #g>0 then
                Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            end
        end
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(3206)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function s.filter2b(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.condition2b(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter2b,1,nil,tp)
end