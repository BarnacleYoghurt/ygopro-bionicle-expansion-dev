--Encounter in the Drifts
function c10100139.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetHintTiming(TIMING_SPSUMMON)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10100139.condition1)
	e1:SetTarget(c10100139.target1)
	e1:SetOperation(c10100139.operation1)
	e1:SetCountLimit(1,10100139+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()	
	e1a:SetHintTiming(TIMING_SUMMON)
	e1a:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()	
	e1b:SetHintTiming(TIMING_FLIPSUMMON)
	e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1b)
end
function c10100139.filter1a(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function c10100139.filter1b(c,e,tp,level)
	return c:IsSetCard(0x15a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(level)
end
function c10100139.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL and ep~=tp
end
function c10100139.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lv = eg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100139.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,lv) and (ep==1-tp or eg:IsExists(c10100139.filter1a,1,nil,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10100139.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local lv = eg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10100139.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,lv)
		if g:GetCount()>0 then
			local sc=g:GetFirst()
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetOperation(c10100139.operation1_1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end
end
function c10100139.operation1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
