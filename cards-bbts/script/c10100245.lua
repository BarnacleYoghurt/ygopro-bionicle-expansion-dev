--Toa of The Swarm
function c10100245.initial_effect(c)
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c10100245.condition1)
	e1:SetOperation(c10100245.operation1)
	c:RegisterEffect(e1)
  --change atk/def
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetRange(RANGE_MZONE)
  e2:SetCode(EFFECT_SET_ATTACK_FINAL)
  e2:SetCondition(c10100245.condition2)
  e2:SetValue(0)
  c:RegisterEffect(e2)
  local e2b=e2:Clone()
  e2b:SetCode(EFFECT_SET_DEFENSE_FINAL)
  c:RegisterEffect(e2b)
  --Easter Egg
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_SUMMON_SUCCESS)
  e3:SetOperation(c10100245.operation3)
  c:RegisterEffect(e3)
  local e3b=e3:Clone()
  e3b:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e3b)
end
function c10100245.filter1a(c)
  return c:IsReleasable() and c:IsFaceup() and c:IsLevelAbove(5)
end
function c10100245.filter1b(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15d) and c:IsAbleToGraveAsCost()
end
function c10100245.condition1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c10100245.filter1a,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c10100245.filter1b,tp,LOCATION_DECK,0,1,nil)
end
function c10100245.operation1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c10100245.filter1a,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Release(g1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c10100245.filter1b,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g2,REASON_COST)
end
function c10100245.condition2(e)
  local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and bc:IsSetCard(0x15c)
end
function c10100245.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
end
function c10100245.operation3(e,tp,eg,ep,ev,re,r,rp)
  e:GetHandler():RegisterFlagEffect(10100245,RESET_EVENT+0x6c0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10100245,0))
end