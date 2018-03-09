--Toa Mata Combination - Magma
function c10100057.initial_effect(c)
	aux.AddXyzProcedure(c,c10100057.filter0,6,2)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100057,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c10100057.cost1)
	e1:SetTarget(c10100057.target1)
	e1:SetOperation(c10100057.operation1)
	e1:SetCountLimit(1,10100057) 
	c:RegisterEffect(e1)
end
--Summon Conditions
function c10100057.filter0(c)
	return c:IsSetCard(0x1155)
end
--e1 - Search
function c10100057.filter1a(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1155) and c:IsAbleToGrave()
end
function c10100057.filter1b(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ROCK) and c:GetLevel()==1 and c:IsAbleToHand()
end
function c10100057.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c10100057.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100057.filter1a,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c10100057.filter1b,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100057.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c10100057.filter1a,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and Duel.SendtoGrave(g1,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c10100057.filter1b,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end