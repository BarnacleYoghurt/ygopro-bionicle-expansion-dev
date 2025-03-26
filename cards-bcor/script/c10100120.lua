--Bog Snake, Venomous Rahi
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	--To Pend
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end
function s.filter1a(c)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsMonsterCard() and c:HasLevel()
end
function s.filter1b(c,e,tp,lv)
	return c:IsRace(RACE_REPTILE) and c:IsSetCard(0xb06) and c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(lv)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function s.rescon1(sg,e,tp)
	return Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg:GetSum(Card.GetLevel))
		and Duel.GetMZoneCount(tp,sg)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)+sg:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)>0
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,2,s.rescon1,0,tp,0,s.rescon1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_ONFIELD,0,nil)
	local dg=aux.SelectUnselectGroup(g,e,tp,1,2,s.rescon1,1,tp,HINTMSG_DESTROY,s.rescon1)
	if #dg>0 and Duel.Destroy(dg,REASON_EFFECT)>0 then
		local lv=Duel.GetOperatedGroup():GetSum(Card.GetLevel)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv):GetFirst()
		if sc and Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			sc:CompleteProcedure()
			Duel.BreakEffect()
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then
				Duel.SendtoGrave(sc,REASON_RULE,nil,PLAYER_NONE)
			elseif Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				-- as a Continuous Spell
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetValue(TYPE_SPELL|TYPE_CONTINUOUS)
				e1:SetReset(RESET_EVENT+(RESETS_STANDARD-RESET_TURN_SET))
				sc:RegisterEffect(e1)
			end
		end
	end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsMonsterCard),tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsMonsterCard),tp,LOCATION_SZONE,0,nil)*300
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.filter3(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE) and c:IsSetCard(0xb06) and c:IsType(TYPE_PENDULUM)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA,0,1,nil,tp)
			and Duel.CheckPendulumZones(tp)
	end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	--Cannot activate Bog Snake effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetValue(s.value3_1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

	if Duel.CheckPendulumZones(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_EXTRA,0,1,1,nil,tp)
		if #g>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function s.value3_1(e,re,tp)
	return re:GetHandler():IsCode(id) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end