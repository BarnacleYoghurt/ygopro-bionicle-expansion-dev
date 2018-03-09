--Nui-Rama, Fly Rahi
function c10100105.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Unrespondable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10100105.condition1)
	e1:SetOperation(c10100105.operation1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100105,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)	
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c10100105.target2)
	e2:SetOperation(c10100105.operation2)
	e2:SetCountLimit(1,10100105)
	c:RegisterEffect(e2)
end
function c10100105.limit1(e,rp,tp)
	return tp==rp
end
function c10100105.condition1(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x15a) and tc:IsRace(RACE_INSECT) and tc:GetLevel()==5	
end
function c10100105.operation1(e,tp,eg,ep,ev,re,r,rp)
	local sc=eg:GetFirst()
	while sc do
		if sc:IsSetCard(0x15a) and sc:GetSummonType()==SUMMON_TYPE_PENDULUM then
			Duel.SetChainLimit(c10100105.limit1)
			sc=nil
		else
			sc=eg:GetNext()
		end
	end
end
function c10100105.filter2a(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x15a) and Duel.IsExistingMatchingCard(c10100105.filter2b,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetRace(),c:GetLevel())
end
function c10100105.filter2b(c,e,tp,r,l)
	return c:IsSetCard(0x15a) and c:IsRace(r) and c:IsLevelBelow(l) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100105.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100105.filter2a,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c10100105.filter2a,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		local tc = g1:GetFirst()
		local g2 = Duel.GetMatchingGroup(c10100105.filter2b,tp,LOCATION_DECK,0,nil,e,tp,tc:GetRace(),tc:GetLevel())
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,tp,LOCATION_DECK)
	end
end
function c10100105.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local tc=Duel.GetFirstTarget()
		local g=Duel.SelectMatchingCard(tp,c10100105.filter2b,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetRace(),tc:GetLevel())
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
				e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
				while tc do
					tc:RegisterEffect(e1)
					tc=g:GetNext()
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end
