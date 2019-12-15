--Exo Armaments
function c10100251.initial_effect(c)
  --Search
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c10100251.target1)
  e1:SetOperation(c10100251.operation1)
  c:RegisterEffect(e1)
  --Armaments (Claw)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(10100251,0))
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCondition(c10100251.condition2)
  e2:SetCost(c10100251.cost2)
  e2:SetOperation(c10100251.operation2)
  e2:SetCountLimit(1,10100251)
  c:RegisterEffect(e2)
  --Armaments (Armor)
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(10100251,1))
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetCondition(c10100251.condition2)
  e3:SetCost(c10100251.cost2)
  e3:SetOperation(c10100251.operation3)
  e3:SetCountLimit(1,10100251)
  c:RegisterEffect(e3)
  --Armaments (Rocket)
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_DESTROY)
  e4:SetDescription(aux.Stringid(10100251,2))
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetRange(LOCATION_GRAVE)
  e4:SetCode(EVENT_FREE_CHAIN)
  e4:SetCondition(c10100251.condition2)
  e4:SetCost(c10100251.cost2)
  e4:SetTarget(c10100251.target4)
  e4:SetOperation(c10100251.operation4)
  e4:SetCountLimit(1,10100251)
  c:RegisterEffect(e4)
end
function c10100251.filter1a(c,e,tp)
  return c:IsSetCard(0x155) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false)
end
function c10100251.filter1b(c)
  return c:IsCode(10100250) and not c:IsForbidden()
end
function c10100251.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then 
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
      and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
      and Duel.IsExistingMatchingCard(c10100251.filter1a,tp,LOCATION_HAND,0,1,nil,e,tp) 
      and Duel.IsExistingMatchingCard(c10100251.filter1b,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
  end
  local g1=Duel.GetMatchingGroup(c10100251.filter1b,tp,LOCATION_HAND,0,nil,e,tp)
  local g2=Duel.GetMatchingGroup(c10100251.filter1b,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,g2,1,0,0)
end
function c10100251.operation1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  local g1=Duel.SelectMatchingCard(tp,c10100251.filter1a,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g1:GetCount()>0 and Duel.SpecialSummon(g1,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP) then
    local g2=Duel.SelectMatchingCard(tp,c10100251.filter1b,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g2:GetCount()>0 then
      Duel.BreakEffect()
      Duel.Equip(tp,g2:GetFirst(),g1:GetFirst())
    end
  end
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10100251.filter2(c)
  return c:IsFaceup() and c:IsCode(10100250)
end
function c10100251.condition2(e,tp,eg,ep,ev,re,r,rp)
  return aux.exccon(e) and Duel.IsExistingMatchingCard(c10100251.filter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10100251.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToRemoveAsCost() end
  Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c10100251.operation2(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTargetRange(0,1)
  e1:SetCode(EFFECT_CANNOT_ACTIVATE)
  e1:SetCondition(c10100251.condition2_1)
  e1:SetValue(c10100251.value2_1)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
end
function c10100251.condition2_1(e)
  local a=Duel.GetAttacker()
  local t=Duel.GetAttackTarget()
  local tp=e:GetHandler()
	return (a and a:IsCode(10100250) and a:IsControler(tp)) or (t and t:IsCode(10100250) and t:IsControler(tp))
end
function c10100251.value2_1(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c10100251.operation3(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetTargetRange(LOCATION_ONFIELD,0)
  e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,10100250))
  e1:SetValue(c10100251.value3_1)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
  local e1b=e1:Clone()
  e1b:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e1b:SetValue(aux.tgoval)
  Duel.RegisterEffect(e1b,tp)
end
function c10100251.value3_1(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c10100251.filter4a(c,tp)
  return c:IsFaceup() and c:IsCode(10100250) and Duel.IsExistingMatchingCard(c10100251.filter4b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c:GetSequence(),tp)
end
function c10100251.filter4b(c,seq,tp)
  return c:IsDestructable() and ((c:IsControler(tp) and c:GetSequence()==seq) or (c:IsControler(1-tp) and c:GetSequence()==4-seq))
end
function c10100251.target4(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(c10100251.filter4a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
  local g=Duel.SelectTarget(tp,c10100251.filter4a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
end
function c10100251.operation4(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    local g=Duel.SelectMatchingCard(tp,c10100251.filter4b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc,tc:GetSequence(),tp)
    if g:GetCount()>0 then
      Duel.Destroy(g,REASON_EFFECT)
    end
  end
end