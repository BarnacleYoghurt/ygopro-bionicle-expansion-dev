--Vahi Freeze
local s,id=GetID()
function s.initial_effect(c)
    --Search or Freeze
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
    --Draw
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
function s.filter1a(c)
    return c:IsSetCard(0xb0d) and c:IsEquipSpell() and c:IsAbleToHand()
end
function s.filter1b(c)
    return c:IsSetCard(0xb0d) and c:IsEquipSpell() and c:IsFaceup()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsFaceup() and chkc:IsOnField() end
    local b1=Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_SZONE,0,1,nil) 
        and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
    if chk==0 then return b1 or b2 end
    local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==2 then
		e:SetCategory(CATEGORY_DISABLE)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
        local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local op=e:GetLabel()
    if op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.filter1a,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    elseif op==2 then
        local tc=Duel.GetFirstTarget()
        if tc:IsRelateToEffect(e) and tc:IsFaceup() then
            tc:NegateEffects(e:GetHandler(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,true)
            local e1a=Effect.CreateEffect(e:GetHandler())
            e1a:SetType(EFFECT_TYPE_SINGLE)
            e1a:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
            e1a:SetRange(LOCATION_ONFIELD)
            e1a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
            e1a:SetValue(1)
            e1a:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1a)
            local e1b=Effect.CreateEffect(e:GetHandler())
            e1b:SetType(EFFECT_TYPE_FIELD)
            e1b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1b:SetRange(LOCATION_ONFIELD)
            e1b:SetTargetRange(1,1)
            e1b:SetCode(EFFECT_CANNOT_REMOVE)
            e1b:SetTarget(function(e,c,tp,r) return c==e:GetHandler() and r==REASON_EFFECT end)
            e1b:SetValue(1)
            e1b:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1b)
        end
    end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)

    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_SKIP_DP)
    e1:SetTargetRange(1,0)
    if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then 
        e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
    else
        e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
    end
    Duel.RegisterEffect(e1,tp)
end