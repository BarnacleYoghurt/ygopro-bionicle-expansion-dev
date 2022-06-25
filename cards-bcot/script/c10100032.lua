--C.C. Matoran Maku
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCost(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
	--Make unaffected
	local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,{id,1})
	c:RegisterEffect(e2)
end
s.listed_series={0xb01}
function s.filter1(c)
  return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsControler(1-tp) and rc:IsLocation(LOCATION_ONFIELD) and not rc:IsLocation(LOCATION_FZONE)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local rc=re:GetHandler()
  local zone=rc:GetColumnZone(LOCATION_MZONE,nil,nil,tp)&0x1f
  local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false,POS_FACEUP,tp,zone) and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local rc=re:GetHandler()
  local zone=rc:GetColumnZone(LOCATION_MZONE,nil,nil,tp)&0x1f
  if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP,zone)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
  end
end
function s.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb01)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_ONFIELD) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    local reset=RESET_CHAIN
    if s.filter2(tc) then reset=RESET_PHASE+PHASE_END end
    
		local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(3100)
		e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.value2_1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
		tc:RegisterEffect(e1)
  end
end
function s.value2_1(e,te)
	return te:GetHandler()~=e:GetHandler()
end