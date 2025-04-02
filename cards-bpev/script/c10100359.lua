--Vahi Freeze
local s,id=GetID()
function s.initial_effect(c)
    --Search or Freeze
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
    --Set
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(s.condition2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
s.listed_series={0xb0d}
function s.filter1a(c,tp,z)
    return c:IsFaceup() and Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,tp,c,z)
end
function s.filter1b(c)
    return c:GetEquipGroup():IsExists(s.filter1d,1,nil)
end
function s.filter1c(c,tp,tc,z)
    return c:IsSetCard(0xb0d) and c:IsEquipSpell() and c:CheckEquipTarget(tc)
        and c:GetEquipTarget()~=tc and c:CheckUniqueOnField(tp) and not c:IsForbidden()
        and (Duel.GetLocationCount(tp,LOCATION_SZONE)>z or c:IsLocation(LOCATION_SZONE))
        and (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD))
end
function s.filter1d(c)
    return c:IsSetCard(0xb0d) and c:IsEquipSpell() and c:IsFaceup()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    --The equip effect needs to account for 1 more zone if this card is not yet on the field
    local z=e:GetHandler():IsOnField() and 0 or 1
    if chkc then
        if e:GetLabel()==1 then return s.filter1a(chkc,tp,z) and chkc:IsLocation(LOCATION_MZONE) end
        if e:GetLabel()==2 then return chkc:IsFaceup() and chkc:IsOnField() and chkc~=e:GetHandler() end
        return false
    end
    local b1=Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,z)
    local b2=Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
    if chk==0 then return b1 or b2 end
    local op=Duel.SelectEffect(tp,
        {b1,aux.Stringid(id,0)},
        {b2,aux.Stringid(id,1)})
    e:SetLabel(op)
    if op==1 then
        e:SetCategory(CATEGORY_EQUIP)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,z)
        Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_ONFIELD)
    elseif op==2 then
        e:SetCategory(CATEGORY_DISABLE)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
        local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
        Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
    end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local op=e:GetLabel()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        if op==1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
            local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1c),tp,
                LOCATION_DECK+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,tp,tc,0)
            if #g>0 then
                Duel.Equip(tp,g:GetFirst(),tc)
            end
        elseif op==2 then
            local reset=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END
            tc:NegateEffects(e:GetHandler(),reset,true)
            local e1a=Effect.CreateEffect(e:GetHandler())
            e1a:SetType(EFFECT_TYPE_SINGLE)
            e1a:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
            e1a:SetRange(LOCATION_ONFIELD)
            e1a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
            e1a:SetValue(1)
            e1a:SetReset(reset)
            tc:RegisterEffect(e1a)
            local e1b=Effect.CreateEffect(e:GetHandler())
            e1b:SetType(EFFECT_TYPE_FIELD)
            e1b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1b:SetRange(LOCATION_ONFIELD)
            e1b:SetTargetRange(1,1)
            e1b:SetCode(EFFECT_CANNOT_REMOVE)
            e1b:SetTarget(function(e,c,tp,r) return c==e:GetHandler() and r==REASON_EFFECT end)
            e1b:SetValue(1)
            e1b:SetReset(reset)
            tc:RegisterEffect(e1b)
            local e1c=Effect.CreateEffect(e:GetHandler())
            e1c:SetDescription(aux.Stringid(id,3))
            e1c:SetType(EFFECT_TYPE_SINGLE)
            e1c:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1c:SetReset(reset)
            tc:RegisterEffect(e1c)
        end
    end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,tp,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsSSetable() and Duel.SSet(tp,c)>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(id,4))
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
        e1:SetCode(EFFECT_SKIP_DP)
        e1:SetTargetRange(1,0)
        if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
            e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
        else
            e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
        end
        Duel.RegisterEffect(e1,tp)
    end
end