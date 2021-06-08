--Tarakava, Lizard Rahi
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Unrespondable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.condition1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end
function s.limit1(e,rp,tp)
	return tp==rp
end
function s.condition1(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_PZONE,0)
	local tc=(g-e:GetHandler()):GetFirst()
	return tc and tc:IsSetCard(0xb06) and tc:IsRace(RACE_REPTILE) and tc:GetLevel()==6
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local sc=eg:GetFirst()
	while sc do
		if sc:IsSetCard(0xb06) and sc:GetSummonType()==SUMMON_TYPE_PENDULUM then
			Duel.SetChainLimit(s.limit1)
			sc=nil
		else
			sc=eg:GetNext()
		end
	end
end
function s.filter2(c,e,tp)
	return c:IsSetCard(0xb06) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_EXTRA)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.Destroy(e:GetHandler(),REASON_EFFECT) then
			local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
