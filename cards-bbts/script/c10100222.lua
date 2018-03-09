--Bohrok Confrontation
function c10100222.initial_effect(c)
	--operation1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c10100222.condition1)
	e1:SetCost(c10100222.cost1)
	e1:SetTarget(c10100222.target1)
	e1:SetOperation(c10100222.operation1)
	c:RegisterEffect(e1)
end
function c10100222.filter1a(c)
	return c:IsSetCard(0x15d) and c:IsAbleToGraveAsCost()
end
function c10100222.filter1b(c)
	return c:IsSetCard(0x15c) and c:IsFaceup()
end
function c10100222.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c10100222.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100222.filter1a,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10100222.filter1a,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end 
end
function c10100222.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100222.filter1b,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10100222.filter1b,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10100222.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1a=Effect.CreateEffect(e:GetHandler())
		e1a:SetType(EFFECT_TYPE_SINGLE)
		e1a:SetCode(EFFECT_UPDATE_ATTACK)
		e1a:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1a:SetValue(400)
		local e1b=Effect.CreateEffect(e:GetHandler())
		e1b:SetType(EFFECT_TYPE_SINGLE)
		e1b:SetCode(EFFECT_UPDATE_DEFENSE)
		e1b:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1b:SetValue(400)
		tc:RegisterEffect(e1a)
		tc:RegisterEffect(e1b)
	end
end
