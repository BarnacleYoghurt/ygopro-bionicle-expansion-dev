Duel.LoadScript("util-bmol.lua")
--The Principle Of Peace
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE|CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.activate1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Replace destruction
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(s.condition2)
    e2:SetTarget(s.target2)
    e2:SetValue(s.value2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
    --Track resolved monster effects
    aux.GlobalCheck(s,function()
        local ge=Effect.CreateEffect(c)
        ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
        ge:SetCode(EVENT_CHAIN_SOLVING)
        ge:SetOperation(s.checkop_res)
        Duel.RegisterEffect(ge,0)
    end)
end
function s.checkop_res(e,tp,eg,ep,ev,re,r,rp)
    if re:IsMonsterEffect() then
        Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
    end
end
function s.filter1(c)
    return c:IsFaceup() and (c:IsSetCard(SET_TOA) or c:IsSetCard(SET_MATORAN) or c:IsSetCard(SET_TURAGA))
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil)
       and Duel.GetFlagEffect(tp,id)==0
       and (re:IsMonsterEffect() or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
    end
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
    local ec=re:GetHandler()
    if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
        ec:CancelToGrave()
        Duel.SendtoDeck(ec,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end
function s.filter2(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
       and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_BATTLE|REASON_EFFECT)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_WARRIOR),tp,LOCATION_MZONE,0,1,nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemove() and eg:IsExists(s.filter2,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,c,96)
end
function s.value2(e,c)
    return s.filter2(c,e:GetHandlerPlayer())
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT|REASON_REPLACE)
end