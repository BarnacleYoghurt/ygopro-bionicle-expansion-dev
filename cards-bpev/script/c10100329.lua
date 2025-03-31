--Nuva Overcharge
local s,id=GetID()
function s.initial_effect(c)
    --Rewrite
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Set
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCondition(s.condition2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
s.listed_series={0xb02,0x3b02,0xb0c}
function s.filter1(c)
    return c:IsSetCard(0xb0c) and c:IsType(TYPE_CONTINUOUS) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and re:IsMonsterEffect() and re:GetActivateLocation()==LOCATION_MZONE
        and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x3b02),tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return re:GetHandler():IsAbleToRemove() end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeTargetCard(ev,Group.CreateGroup())
    Duel.ChangeChainOperation(ev,s.operation1_1)
end
function s.operation1_1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
    end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x3b02),tp,LOCATION_MZONE,0,1,nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsSSetable() then
        Duel.SSet(tp,c)
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(3300)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetValue(LOCATION_REMOVED)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        c:RegisterEffect(e1)
    end
end