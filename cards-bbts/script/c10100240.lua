--Mata Nui Fishing Bird, Rahi
function c10100240.initial_effect(c)
	--Banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10100240.cost1)
	e1:SetTarget(c10100240.target1)
	e1:SetOperation(c10100240.operation1)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,10100240)
	c:RegisterEffect(e1)
end

function c10100240.filter1a(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15a) and c:IsAbleToRemoveAsCost()
end
function c10100240.filter1b(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackAbove(2000)
end
function c10100240.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10100240.filter1a,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100240.filter1a,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100240.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	if g:IsExists(c10100240.filter1b,1,nil) then
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
	end
end
function c10100240.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if c10100240.filter1b(tc) then
			local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
			if g:GetCount()>0 then
				local sg=g:RandomSelect(tp,1)
				Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
