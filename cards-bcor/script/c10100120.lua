--Bog Snake, Venomous Rahi
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--Synchro
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,{id,1})
	c:RegisterEffect(e2)
	--To S/T
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1,{id,2})
	c:RegisterEffect(e3)
end
function s.filter1(c,tp)
	return c:IsSetCard(0xb06) and c:IsControler(tp)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter1,1,nil,tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function s.filter2a(c)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsMonsterCard() and c:HasLevel()
end
function s.filter2b(c,e,tp,lv)
	return c:IsRace(RACE_REPTILE) and c:IsSetCard(0xb06) and c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(lv)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function s.rescon2(sg,e,tp)
	return Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg:GetSum(Card.GetLevel))
		and Duel.GetMZoneCount(tp,sg)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)+sg:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)>0
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.filter2a(chkc) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) end
	local g=Duel.GetMatchingGroup(s.filter2a,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,2,s.rescon2,0,tp,0,s.rescon2) end
	g=aux.SelectUnselectGroup(g,e,tp,1,2,s.rescon2,1,tp,HINTMSG_DESTROY,s.rescon2)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetTargetCards(e)
	if Duel.Destroy(dg,REASON_EFFECT)>0 then
		local lv=Duel.GetOperatedGroup():GetSum(Card.GetLevel)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv):GetFirst()
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
function s.filter3(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsRace(RACE_REPTILE) and c:IsSetCard(0xb06)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter3),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,tp)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter3),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,tp)
		if #g>0 and Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			-- as a Continuous Spell
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_SPELL|TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+(RESETS_STANDARD-RESET_TURN_SET))
			g:GetFirst():RegisterEffect(e1)
		end
	end
end