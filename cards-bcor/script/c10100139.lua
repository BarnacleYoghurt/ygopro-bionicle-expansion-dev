--Encounter in the Drifts
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetHintTiming(TIMING_SPSUMMON)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
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
function s.filter1a(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function s.filter1b(c,e,tp,level)
	return c:IsSetCard(0xb06) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(level)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL and ep~=tp
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lv = eg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,lv) and (ep==1-tp or eg:IsExists(s.filter1a,1,nil,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local lv = eg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,lv)
		if g:GetCount()>0 then
      --Case handling from Magical Meltdown
      if Duel.GetCurrentChain()==0 then --Probably not actually possible, but here just in case
        Duel.SetChainLimitTillChainEnd(aux.FALSE)
      elseif Duel.GetCurrentChain()==1 then
        --Set flag on summon and reset it if something else happens (which shouldn't ever, but just in case)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_SPSUMMON_SUCCESS)
        e1:SetOperation(s.operation1_1)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        --Prevent chaining other cards to the summon once this card's chain ends
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetRange(LOCATION_FZONE)
        e2:SetCode(EVENT_CHAIN_END)
        e2:SetOperation(s.operation1_2)
        Duel.RegisterEffect(e2,tp)
      end
      --CL2 or higher don't get the protection because rulings
      
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.operation1_1(e,tp,eg,ep,ev,re,r,rp)
  Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_CHAINING)
  e1:SetOperation(s.operation1_1_1)
  Duel.RegisterEffect(e1,tp)
  local e2=e1:Clone()
  e2:SetCode(EVENT_BREAK_EFFECT)
  e2:SetReset(RESET_CHAIN)
  Duel.RegisterEffect(e2,tp)
end
function s.operation1_1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,id)
	e:Reset()
end
function s.operation1_2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)~=0 then
		Duel.SetChainLimitTillChainEnd(aux.FALSE)
	end
	Duel.ResetFlagEffect(tp,id)
end