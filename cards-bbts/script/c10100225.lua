--If You Wake One...
function c10100225.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Extra Summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c10100225.condition1)
	e1:SetTarget(c10100225.target1)
	e1:SetOperation(c10100225.operation1)
	e1:SetCountLimit(1,10100225)
	c:RegisterEffect(e1)
	--Relay
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c10100225.cost2)
	e2:SetTarget(c10100225.target2)
	e2:SetOperation(c10100225.operation2)
	e2:SetCountLimit(1,11100225)
	c:RegisterEffect(e2)
end
function c10100225.filter1a(c,tp)
	return c:IsControler(tp) and c:IsFacedown()
end
function c10100225.filter1b(c,e,tp)
	return c:IsSetCard(0x15c) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100225.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10100225.filter1a,1,nil,tp)
end
function c10100225.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and Duel.IsExistingMatchingCard(c10100225.filter1b,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c10100225.filter1b,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100225.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10100225.filter1b,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount() > 0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c10100225.filter2(c)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c10100225.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c10100225.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100225.filter2,tp,LOCATION_DECK,0,1,nil) end
end
function c10100225.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c10100225.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g:GetFirst())
		end
	end
end