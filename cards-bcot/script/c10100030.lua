--Le-Koro, Village of Air
function c10100030.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c10100030.operation0)
	c:RegisterEffect(e0)
	--1 less tribute for WATER
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DECREASE_TRIBUTE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100030,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_TARGET)
	e2:SetCost(c10100030.cost2)
	e2:SetTarget(c10100030.target2)
	e2:SetOperation(c10100030.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
--e0 - Activate
function c10100030.filter0a(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function c10100030.filter0b(c)
	return c:IsCode(10100006) and c:IsAbleToHand()
end
function c10100030.operation0(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstMatchingCard(c10100030.filter0b,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(c10100030.filter0a,tp,LOCATION_MZONE,0,1,nil) and tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--e2 - Special Summon
function c10100030.filter2a(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x158) and c:IsAbleToRemoveAsCost()
end
function c10100030.filter2b(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and Duel.IsExistingMatchingCard(c10100030.filter2c,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetLevel())
end
function c10100030.filter2c(c,e,tp,lvl)
	return c:IsLevelBelow(lvl) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100030.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100030.filter2a,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100030.filter2a,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100030.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10100030.filter2b(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10100030.filter2b,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10100030.filter2b,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c10100030.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPECIAL_SUMMMON)
	local g=Duel.SelectMatchingCard(tp,c10100030.filter2c,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetLevel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
