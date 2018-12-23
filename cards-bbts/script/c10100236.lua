--Pokawi, Bird Rahi
function c10100236.initial_effect(c)
	--Reduce ATK
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetCost(c10100236.cost1)
	e1:SetTarget(c10100236.target1)
	e1:SetOperation(c10100236.operation1)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	c:RegisterEffect(e1)
end
function c10100236.filter1a(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15a) and c:IsAbleToRemoveAsCost()
end
function c10100236.filter1b(c)
	return c:IsFaceup() and c:IsSetCard(0x15a)
end
function c10100236.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10100236.filter1a,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100236.filter1a,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100236.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c10100236.operation1(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetMatchingGroupCount(c10100236.filter1b,tp,LOCATION_MZONE,0,nil)*600
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-val)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
	
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		tc:RegisterEffect(e1:Clone())
		tc = tg:GetNext()
	end
end
