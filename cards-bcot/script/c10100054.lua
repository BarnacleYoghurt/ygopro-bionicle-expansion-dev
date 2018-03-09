--Makoki Stone
function c10100054.initial_effect(c)
	c:SetUniqueOnField(1,0,10100054)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetOperation(c10100054.operation2)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100054,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10100054.condition3)
	e3:SetCost(c10100054.cost3)
	e3:SetTarget(c10100054.target3)
	e3:SetOperation(c10100054.operation3)
	c:RegisterEffect(e3)
end
--e2 - Add counter
function c10100054.filter2(c)
	return c:IsSetCard(0x155) or c:IsSetCard(0x156) or c:IsSetCard(0x157)
end
function c10100054.operation2(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler() and c10100054.filter2(re:GetHandler()) then
		e:GetHandler():AddCounter(0x10b1,1)
	end
end
--e3 - Search
function c10100054.filter3(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
function c10100054.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x10b1)>=6
end
function c10100054.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c10100054.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10100054.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100054.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c10100054.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
