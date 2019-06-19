--Matoran Engineer Nuparu
function c10100247.initial_effect(c)
  --Build things in a cave with a box of scraps
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCost(c10100247.cost1)
  e1:SetTarget(c10100247.target1)
  e1:SetOperation(c10100247.operation1)
  e1:SetCountLimit(1,10100247)
  c:RegisterEffect(e1)
  --While others work
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetCost(c10100247.cost2)
  e2:SetCondition(c10100247.condition2)
  e2:SetOperation(c10100247.operation2)
  e2:SetCountLimit(1,10100247)
  c:RegisterEffect(e2)
end
function c10100247.filter1a(c)
  return c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10100247.filter1c,tp,LOCATION_HAND,0,1,nil,c)
end
function c10100247.filter1b(c,e,tp,rc)
  return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) 
    and 
    (
      (not rc and Duel.IsExistingMatchingCard(c10100247.filter1c,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c)) --If no GY card selected yet, check if grave has any applicable
      or 
      (rc and c10100247.filter1c(c,rc)) --If GY card selected, check if that card in particular is applicable
    )
end
function c10100247.filter1c(c,rc)
  return c:GetLevel() == rc:GetLevel()
end
function c10100247.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(c10100247.filter1a, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, nil)
  end
  local g=Duel.SelectMatchingCard(tp,c10100247.filter1a, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, 1, nil)
  e:SetLabelObject(g:GetFirst())
  Duel.Remove(g, POS_FACEUP, REASON_COST)
end
function c10100247.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(c10100247.filter1b, tp, LOCATION_HAND, 0, 1, nil, e, tp, e:GetLabelObject())
  end
  local g=Duel.GetMatchingGroup(c10100247.filter1b, tp, LOCATION_HAND, 0, nil, e, tp, e:GetLabelObject())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end
function c10100247.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g = Duel.SelectMatchingCard(tp, c10100247.filter1b, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp, e:GetLabelObject())
  if g:GetCount() > 0 then
    Duel.SpecialSummon(g,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP_DEFENSE)
  end
end
function c10100247.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c10100247.condition2(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if a:IsStatus(STATUS_OPPO_BATTLE) and d:IsControler(tp) then a,d=d,a end
	if a:IsSetCard(0x157) and a:IsChainAttackable() then
		e:SetLabelObject(a)
		return true
	else return false end
end
function c10100247.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToBattle() then
		Duel.ChainAttack()
	end
end