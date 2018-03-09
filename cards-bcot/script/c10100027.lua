--Onu-Koro, Village of Earth
function c10100027.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c10100027.operation0)
	c:RegisterEffect(e0)
	--1 less tribute for EARTH
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DECREASE_TRIBUTE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100027,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c10100027.cost2)
	e2:SetTarget(c10100027.target2)
	e2:SetOperation(c10100027.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
--e0 - Activate
function c10100027.filter0a(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c10100027.filter0b(c)
	return c:IsCode(10100003) and c:IsAbleToHand()
end
function c10100027.operation0(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstMatchingCard(c10100027.filter0b,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(c10100027.filter0a,tp,LOCATION_MZONE,0,1,nil) and tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--e2 - Draw
function c10100027.filter2a(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x158) and c:IsAbleToRemoveAsCost()
end
function c10100027.filter2b(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c10100027.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100027.filter2a,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100027.filter2a,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100027.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c10100027.filter2b,tp,LOCATION_MZONE,0,nil)
	if ct>3 then ct=3 end
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c10100027.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end