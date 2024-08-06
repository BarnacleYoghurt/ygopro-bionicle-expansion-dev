if not bcor then
	Duel.LoadScript("util-bcor.lua")
end
--Husi, Ostrich Rahi
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--To Pendulum Zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	local e2_grant=bcor.rahi_beast_granteff(c,e2,aux.Stringid(id,1))
	c:RegisterEffect(e2_grant)
end
function s.filter1(c,tp)
	local rchk=c:IsRace(RACE_BEAST|RACE_WINGEDBEAST)
	if c:IsPreviousLocation(LOCATION_MZONE) then rchk=c:IsPreviousRaceOnField(RACE_BEAST|RACE_WINGEDBEAST) end
	return rchk and c:IsPreviousSetCard(0xb06) and c:IsMonsterCard() and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(s.filter1,1,nil,tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.filter2(c,tp)
	return c:IsSetCard(0xb06) and c:IsType(TYPE_PENDULUM) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter2),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,tp)
			and Duel.CheckPendulumZones(tp)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckPendulumZones(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,tp)
		if #g>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end