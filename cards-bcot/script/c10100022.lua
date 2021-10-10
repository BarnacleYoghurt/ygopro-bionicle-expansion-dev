--Turaga Matau
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
	--Recycle
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
	--if not GhostBelleTable then GhostBelleTable={} end
	--table.insert(GhostBelleTable,e2)
	if not AshBlossomTable then AshBlossomTable={} end
	table.insert(AshBlossomTable,e2)
end
function s.filter0(c)
  return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WARRIOR)
end
function s.check0(g,lc)
  return g:IsExists(s.filter0,1,nil)
end
function s.filter1(c,e,tp)
  return c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_SET_ATTACK_FINAL)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD)
      e1:SetValue(0)
      tc:RegisterEffect(e1)
      Duel.SpecialSummonComplete()
    end
  end
end
function s.filter2(c)
  return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
  if chkc then return chkc~=c and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and aux.NecroValleyFilter(s.filter2)(chkc) end 
  if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter2),tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,c)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(id,2))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetLabel(Duel.GetTurnCount())
    e1:SetLabelObject(tc)
    e1:SetCondition(s.condition2_1)
    e1:SetOperation(s.operation2_1)
    if Duel.IsTurnPlayer(tp) then
      e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
    else
      e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
    end
    Duel.RegisterEffect(e1,tp)
    tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
    e:GetHandler():SetCardTarget(tc) --Just to get a visual hint in case of multiple copies, at least while Matau is in GY
  end
end
function s.condition2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp) and Duel.GetTurnCount()~=e:GetLabel()
end
function s.operation2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if e:GetLabelObject():GetFlagEffect(id)~=0 and aux.NecroValleyFilter(s.filter2)(tc) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0) then
      Duel.BreakEffect()
      Duel.Draw(tp,1,REASON_EFFECT)
    end
	end
end