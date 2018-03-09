--Po-Koro, Village of Stone
function c10100028.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c10100028.operation0)
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
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100028,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10100028.condition2)
	e2:SetCost(c10100028.cost2)
	e2:SetTarget(c10100028.target2)
	e2:SetOperation(c10100028.operation2)
	c:RegisterEffect(e2)
end
--e0 - Activate
function c10100028.filter0a(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c10100028.filter0b(c)
	return c:IsCode(10100004) and c:IsAbleToHand()
end
function c10100028.operation0(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstMatchingCard(c10100028.filter0b,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(c10100028.filter0a,tp,LOCATION_MZONE,0,1,nil) and tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--e2 - Special Summon
function c10100028.filter2a(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x158) and c:IsAbleToRemoveAsCost()
end
function c10100028.filter2b(c,maxlr,e,tp)
	return (c:IsRankBelow(maxlr-1) or c:IsLevelBelow(maxlr-1)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function c10100028.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100028.filter2b,tp,LOCATION_EXTRA,0,1,nil,c10100028.calcmaxlr(tp),e,tp)
end
function c10100028.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100028.filter2a,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100028.filter2a,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100028.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c10100028.filter2b,tp,LOCATION_EXTRA,0,1,nil,c10100028.calcmaxlr(tp),e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10100028.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local rt = 2
	if Duel.IsExistingMatchingCard(c10100028.filter2b,tp,LOCATION_EXTRA,0,1,nil,hg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel(),e,tp) then
		rt = 1
	end
	local cg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,rt,2,nil,TYPE_MONSTER)
	local maxlr = cg:GetSum(Card.GetLevel)
	Duel.SendtoGrave(cg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100028.filter2b,tp,LOCATION_EXTRA,0,1,1,nil,maxlr,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		local tc = g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		tc:RegisterEffect(e1)
		local e1a=e1:Clone()
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		tc:RegisterEffect(e1a)
		local e1b=e1a:Clone()
		e1b:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
		tc:RegisterEffect(e1b)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCategory(CATEGORY_TODECK)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetOperation(c10100028.operation2_2)
		tc:RegisterEffect(e2)
	end
end
function c10100028.operation2_2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
function c10100028.calcmaxlr(tp)
	local maxlr = 0
	local g1 = Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2 = Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local tc1 = g1:GetFirst()
	local tc2 = g2:GetFirst()
	while tc1 do
		if tc1:GetLevel()>maxlr then
			maxlr = tc1:GetLevel()
		end
		while tc2 do
			if tc1~=tc2 and tc1:GetLevel()+tc2:GetLevel()>maxlr then
				maxlr = tc1:GetLevel()+tc2:GetLevel()
			end
			tc2 = g2:GetNext()
		end
		tc1 = g1:GetNext()
	end
	return maxlr
end