--Matoran Legend Lhii
local s,id=GetID()
function s.initial_effect(c)
  --Reduce ATK/DEF + negate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_DAMAGE_STEP)
  e1:SetCondition(s.condition1)
  e1:SetCost(s.cost1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Special Summon + increase ATK
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetCurrentPhase()~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
  local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:GetControler()==tp and a:IsAttribute(ATTRIBUTE_FIRE) and a:IsRelateToBattle())
		or (d:GetControler()==tp and d:IsAttribute(ATTRIBUTE_FIRE) and d:IsRelateToBattle()))
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
  local tc=a
  if a:GetControler()==tp then
    tc=d
  end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(-500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e3:SetCode(EFFECT_DISABLE)
  e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e4:SetCode(EFFECT_DISABLE_EFFECT)
  e4:SetValue(RESET_TURN_SET)
  e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e4)
end
function s.filter2(c,tp)
  return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR) and c:IsStatus(STATUS_OPPO_BATTLE)
    and ((c:IsRelateToBattle() and c:IsControler(tp)) or c:IsPreviousControler(tp)) --check previous controller if the card itself was destroyed in the battle
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(s.filter2,1,nil,tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
    local tc=eg:GetFirst():GetBattleTarget()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(tc:GetBaseAttack())
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    
    Duel.SpecialSummonComplete()
  end
end