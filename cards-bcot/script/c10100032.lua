--C.C. Matoran Maku
local s,id=GetID()
function s.initial_effect(c)
	--Make unaffected
	local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
	e1:SetRange(LOCATION_HAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(id,1)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_CHAINING)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCost(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id+1000000)
  c:RegisterEffect(e2)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x157)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    local reset=RESET_CHAIN
    if s.filter1(tc) then reset=RESET_PHASE+PHASE_END end
    
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESETS_STANDARD+reset)
		e1:SetValue(s.value1_1)
		tc:RegisterEffect(e1)
  end
end
function s.value1_1(e,te)
	return te:GetHandler()~=e:GetHandler()
end
function s.filter2(c)
  return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsControler(1-tp) and rc:IsLocation(LOCATION_ONFIELD) and not rc:IsLocation(LOCATION_FZONE)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local rc=re:GetHandler()
  local seq=rc:GetSequence()
  if seq==5 then seq=1 end
  if seq==6 then seq=3 end
  local zone=bit.replace(0,0x1,4-seq)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false,POS_FACEUP,tp,zone) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
  e:SetLabel(zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local zone=e:GetLabel()
  if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP,zone)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
  end
end