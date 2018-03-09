--I am Nothing
function c10100116.initial_effect(c)
	--Activate (Tribute)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(10100116,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(aux.RPGTarget(aux.FilterBoolFunction(Card.IsCode,10100117)))
	e0:SetOperation(aux.RPGOperation(aux.FilterBoolFunction(Card.IsCode,10100117)))
	c:RegisterEffect(e0)
	--Activate (To Deck)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100116,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10100116.target1)
	e1:SetOperation(c10100116.operation1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100116,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c10100116.cost2)
	e2:SetTarget(c10100116.target2)
	e2:SetOperation(c10100116.operation2)
	c:RegisterEffect(e2)
end
function c10100116.filter1a(c)
	return c:IsSetCard(0x158) and c:IsAbleToDeck()
end
function c10100116.filter1b(c,e,tp)
	return c:IsCode(10100117) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c10100116.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100116.filter1a,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(c10100116.filter1b,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10100116.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10100116.filter1b,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c10100116.filter1a,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,1,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	end
end
function c10100116.filter2(c,e)
	return c:GetLevel()>=3 and c:IsAbleToRemoveAsCost()
end
function c10100116.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10100116.filter2,tp,LOCATION_GRAVE,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100116.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100116.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(c10100116.filter1b,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10100116.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100116.filter1b,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	end
end
