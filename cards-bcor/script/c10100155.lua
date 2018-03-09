--Cavern of Light
function c10100155.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c10100155.operation0)
	c:RegisterEffect(e0)
	--To Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100155,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCost(c10100155.cost1)
	e1:SetTarget(c10100155.target1)
	e1:SetOperation(c10100155.operation1)
	e1:SetCountLimit(1,10100155)
	c:RegisterEffect(e1)
end
function c10100155.filter(c)
	return c:IsCode(10100154) and c:IsAbleToHand()
end
function c10100155.operation0(e,tp,eg,ep,ev,re,r,rp,chk)	
	if e:GetHandler():IsRelateToEffect(e) then
		local tc=Duel.GetFirstMatchingCard(c10100155.filter,tp,LOCATION_DECK,0,nil)
		if tc and Duel.SelectYesNo(tp,aux.Stringid(10100155,1)) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c10100155.filter1(c)
	return c:IsFaceup() and (c:IsAttribute(ATTRIBUTE_EARTH) or c:IsSetCard(0x157)) and c:IsAbleToHand()
end
function c10100155.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100155.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100155.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c10100155.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100155.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c10100155.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local tc=Duel.GetFirstMatchingCard(c10100155.filter,tp,LOCATION_GRAVE,0,nil)
		if tc then	
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
