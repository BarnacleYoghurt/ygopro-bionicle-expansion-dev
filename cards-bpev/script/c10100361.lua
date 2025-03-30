--Sterling Silver Krana-Kal
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Cannot be Link Summoned
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)
    --Special Summon by banishing Krana-Kal
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
    --Unaffected
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetTarget(aux.TargetBoolFunction(s.filter2))
    e2:SetValue(s.value2)
    c:RegisterEffect(e2)
    --Win Match
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE) -- Ruling: Does not "affect" 
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetCode(EFFECT_MATCH_KILL)
    e3:SetTarget(s.target3)
    c:RegisterEffect(e3)
end
function s.filter1a(c)
    return c:IsLink(1) and c:IsSetCard(0xb09) and c:IsAbleToRemoveAsCost()
end
function s.filter1b(c)
    return c:IsFaceup() and c:IsSetCard(0xb08) and c:IsType(TYPE_XYZ)
end
function s.rescon1(sg,e,tp,mg)
    -- Performance warning: Group.SelectUnselect doesn't play too well with "large" groups
    -- In particular, having the same name that's clogging the EMZ available elsewhere slows us to a crawl
    -- Preserving the second return of aux.dncheck (fast-fail condition) helps a little, but not entirely
    -- (Insufficient LocationCount can't be made part of stop, because adding more cards can fix it)
    local res,stop=aux.dncheck(sg,e,tp,mg)
    return (res and Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0),stop
end
function s.condition1(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
    g=g+Duel.GetOverlayGroup(tp,1,0):Filter(s.filter1a,nil)
    return Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_MZONE,0,1,nil)
        and aux.SelectUnselectGroup(g,e,tp,8,8,s.rescon1,0)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
    g=g+Duel.GetOverlayGroup(tp,1,0):Filter(s.filter1a,nil)
    local sg=aux.SelectUnselectGroup(g,e,tp,8,8,s.rescon1,1,tp,HINTMSG_REMOVE,nil,nil,true)
    if #sg>0 then
        sg:KeepAlive()
        e:SetLabelObject(sg)
        return true
    end
    return false
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp,c)
    local sg=e:GetLabelObject()
    if not sg then return end
    Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function s.filter2(c)
    return c:IsFaceup() and c:IsSetCard(0xb08)
end
function s.value2(e,re,c)
    return c~=re:GetOwner()
end
function s.target3(e,c)
    return c:IsSetCard(0xb08) and e:GetHandler():GetLinkedGroup():IsContains(c)
end