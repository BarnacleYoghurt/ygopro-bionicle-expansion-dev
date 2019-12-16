--The Chronicler's Courage
function c10100253.initial_effect(c)
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(10100253,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetRange(LOCATION_SZONE)
  e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
  e1:SetCondition(c10100253.condition1)
  e1:SetTarget(c10100253.target1)
  e1:SetOperation(c10100253.operation1)
  c:RegisterEffect(e1)
  --Indestructible
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
  e2:SetTarget(c10100253.target2)
  e2:SetValue(c10100253.value2)
  c:RegisterEffect(e2)
end
function c10100253.filter1(c,e,tp)
  return c:GetLevel()==2 and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false)
end
function c10100253.condition1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>0
end
function c10100253.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100253.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
  end
  local g=Duel.GetMatchingGroup(c10100253.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100253.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,c10100253.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)
  end
end
function c10100253.target2(e,c)
  return c:GetLevel()==2 and c:IsRace(RACE_WARRIOR)
end
function c10100253.value2(e,re,r,rp)
  if bit.band(r,REASON_BATTLE)~=0 then
    return 1
  else
    return 0
  end
end