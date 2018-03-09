--Cliff Bug, Rahi
function c10100153.initial_effect(c)
	--Unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100153,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c10100153.condition1)
	e1:SetCost(c10100153.cost1)
	e1:SetTarget(c10100153.target1)
	e1:SetOperation(c10100153.operation1)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,10100153)
	c:RegisterEffect(e1)
end
function c10100153.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15a) and c:IsAbleToRemoveAsCost()
end
function c10100153.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
end
function c10100153.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10100153.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100153.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100153.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c10100153.operation1(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()>0 then
		local tc=Duel.GetFirstTarget()
		local ac=eg:GetFirst()
		local t=bit.band(ac:GetType(),TYPE_MONSTER)+bit.band(ac:GetType(),TYPE_SPELL)+bit.band(ac:GetType(),TYPE_TRAP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetLabel(t)
		e1:SetValue(c10100153.value1_1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c10100153.value1_1(e,te)
	if te:IsActiveType(e:GetLabel()) then return true end
end
