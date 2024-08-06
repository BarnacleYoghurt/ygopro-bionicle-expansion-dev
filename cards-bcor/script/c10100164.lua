--Lightfish, Luminescent Rahi
local s,id=GetID()
function s.initial_effect(c)
    --LIGHT
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e1:SetValue(ATTRIBUTE_LIGHT)
    c:RegisterEffect(e1)
    --Illuminate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCost(s.cost2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    c:RegisterEffect(e2)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemoveAsCost() end
    Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.filter2a(c,tp)
    return c:IsCanChangePosition() or s.filter2b(c,tp)
end
function s.filter2b(c,tp)
    return c:IsFaceup() and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT>0)
        and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter2a(chkc,tp) and chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(s.filter2a,1-tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,s.filter2a,1-tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.SetPossibleOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
    Duel.SetPossibleOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local op=Duel.SelectEffect(tp,
            {tc:IsCanChangePosition(),aux.Stringid(id,1)},
            {s.filter2b(tc,tp),aux.Stringid(id,2)}
        )
        if op==1 then
            Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
        elseif op==2 and Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(3302)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetCode(EFFECT_CANNOT_TRIGGER)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
        end
    end
end