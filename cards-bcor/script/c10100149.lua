--Matoran Translator Matoro
local s,id=GetID()
function s.initial_effect(c)
	--Flag
	local e0a=Effect.CreateEffect(c)
	e0a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0a:SetCode(EVENT_SUMMON_SUCCESS)
	e0a:SetOperation(s.operation0)
	c:RegisterEffect(e0a)
  local e0b=e0a:Clone()
  e0b:SetCode(EVENT_FLIP)
  c:RegisterEffect(e0b)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
  --Flip
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_POSITION)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_CHANGE_POS)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCondition(s.condition2)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id+1000000)
  c:RegisterEffect(e2)
end
function s.operation0(e,tp,eg,ep,ev,re,r,rp)
  local rst=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END
  if e:GetCode()==EVENT_SUMMON_SUCCESS then
    rst=rst-(RESET_TEMP_REMOVE+RESET_LEAVE)
  end
	e:GetHandler():RegisterFlagEffect(id,rst,0,1)
end
function s.filter1(c,e,tp)
	return c:IsSetCard(0xb01) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_GRAVE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_GRAVE,0,1,2,nil,e,tp)	
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	
	end
end
function s.filter2a(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown() and c:IsControler(tp)
end
function s.filter2b(c)
	return c:IsFacedown() and c:IsLocation(LOCATION_MZONE) and c:IsCanChangePosition()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter2a,1,nil,tp)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(s.filter2b,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:FilterCount(s.filter2b,nil),0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChangePosition(eg:Filter(s.filter2b,nil),POS_FACEUP_DEFENSE)
end