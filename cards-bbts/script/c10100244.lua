--Turaga of The Swarm
function c10100244.initial_effect(c)
  --synchro summon
  local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(10100244,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_SUMMON+TIMING_SPSUMMON)
	e1:SetCost(c10100244.cost1)
	e1:SetTarget(c10100244.target1)
	e1:SetOperation(c10100244.operation1)
  e1:SetCountLimit(1)
	c:RegisterEffect(e1)
  --take control
  local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
  e2:SetDescription(aux.Stringid(10100244,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c10100244.condition2)
	e2:SetTarget(c10100244.target2)
	e2:SetOperation(c10100244.operation2)
	c:RegisterEffect(e2)
end
function c10100244.filter1a(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15d) and c:IsAbleToGraveAsCost()
end
function c10100244.filter1b(c)
  return c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsAbleToRemove()
end
function c10100244.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100244.filter1a,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10100244.filter1a,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function c10100244.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100244.filter1b,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10100244.filter1b,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c10100244.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then 
    if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
      Duel.BreakEffect()
      Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
      local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,1-tp,LOCATION_EXTRA,0,nil,c)
      if g:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
        local sg=g:Select(1-tp,1,1,nil)
        Duel.SynchroSummon(1-tp,sg:GetFirst(),c)
      end
    end
  end
end
function c10100244.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c10100244.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_CONTROL,rc,1,0,0)
end
function c10100244.operation2(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
  
  if rc:IsFaceup() and rc:IsLocation(LOCATION_MZONE) then
    Duel.GetControl(rc,tp,PHASE_END,1)
    
    local e1=Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(10100244,2))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetRange(RANGE_MZONE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetCondition(c10100244.condition2_1)
    e1:SetValue(0)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    rc:RegisterEffect(e1,true)
    local e1b=e1:Clone()
    e1b:SetCode(EFFECT_SET_DEFENSE_FINAL)
    rc:RegisterEffect(e1b,true)
    if not rc:IsType(TYPE_EFFECT) then
      local e2=Effect.CreateEffect(rc)
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_CHANGE_TYPE)
      e2:SetValue(rc:GetType()+TYPE_EFFECT)
      e2:SetReset(RESET_EVENT+0x1fe0000)
      rc:RegisterEffect(e2)
    end
  end
end
function c10100244.condition2_1(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and bc:IsSetCard(0x15c)
end