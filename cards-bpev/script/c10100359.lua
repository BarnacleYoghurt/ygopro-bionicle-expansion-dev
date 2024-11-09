--Vahi Freeze
local s,id=GetID()
function s.initial_effect(c)
    --Search or Freeze
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
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
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(3100)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
            e1:SetRange(LOCATION_ONFIELD)
            e1:SetCode(EFFECT_IMMUNE_EFFECT)
            e1:SetValue(function (e,te) return e:GetOwner()~=te:GetOwner() end)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
        end
    end
end
