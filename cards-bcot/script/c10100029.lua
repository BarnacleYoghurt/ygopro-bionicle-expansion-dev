--Ko-Koro, Village of Ice
function c10100029.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c10100029.operation0)
	c:RegisterEffect(e0)
	--1 less tribute for WATER
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DECREASE_TRIBUTE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Gain LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100029,0))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c10100029.condition2)
	e2:SetCost(c10100029.cost2)
	e2:SetTarget(c10100029.target2)
	e2:SetOperation(c10100029.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
--e0 - Activate
function c10100029.filter0a(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c10100029.filter0b(c)
	return c:IsCode(10100005) and c:IsAbleToHand()
end
function c10100029.operation0(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstMatchingCard(c10100029.filter0b,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(c10100029.filter0a,tp,LOCATION_MZONE,0,1,nil) and tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--e2 - Gain LP
function c10100029.filter2a(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x158) and c:IsAbleToRemoveAsCost()
end
function c10100029.filter2b(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c10100029.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c10100029.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100029.filter2a,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100029.filter2a,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100029.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,ev)
end
function c10100029.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,ev,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c10100029.filter2b,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ev)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
