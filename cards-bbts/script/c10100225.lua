--If You Wake One...
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Extra Summon
	local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--Relay
	local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id+1000000)
	c:RegisterEffect(e2)
end
function s.filter1a(c,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function s.filter1b(c,e,tp)
	return c:IsSetCard(0xb08) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter1a,1,nil,tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount() > 0 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
        Duel.ConfirmCards(1-tp,g)
        local c=e:GetHandler()
        local fid=c:GetFieldID()
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCondition(s.condition1_1)
        e1:SetOperation(s.operation1_1)
        e1:SetLabel(fid)
        e1:SetCountLimit(1)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
      end
		end
	end
end 
function s.condition1_1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.operation1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function s.filter2(c)
	return c:IsSetCard(0xb08) and c:IsType(TYPE_TRAP) and not c:IsCode(id) and c:IsSSetable()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g:GetFirst())
		end
	end
end