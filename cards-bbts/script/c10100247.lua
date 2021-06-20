--Matoran Engineer Nuparu
local s,id=GetID()
function s.initial_effect(c)
  --Build things in a cave with a box of scraps
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCost(s.cost1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetLabelObject(nil)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --While others work
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetCondition(s.condition2)
  e2:SetCost(s.cost2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
function s.filter1a(c,tp)
  return c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_HAND,0,1,nil,c)
end
function s.filter1b(c,e,tp,rc)
  return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false,POS_FACEUP_DEFENSE) 
    and 
    (
      (not rc and Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c)) --If no GY card selected yet, check if grave has any applicable
      or 
      (rc and s.filter1c(c,rc)) --If GY card selected, check if that card in particular is applicable
    )
end
function s.filter1c(c,rc)
  return c:GetLevel() == rc:GetLevel()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(s.filter1a, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, nil,tp)
  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,s.filter1a, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, 1, nil,tp)
  e:SetLabelObject(g:GetFirst())
  Duel.Remove(g, POS_FACEUP, REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter1b, tp, LOCATION_HAND, 0, 1, nil, e, tp, e:GetLabelObject())
  end
  local g=Duel.GetMatchingGroup(s.filter1b, tp, LOCATION_HAND, 0, nil, e, tp, e:GetLabelObject())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g = Duel.SelectMatchingCard(tp, s.filter1b, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp, e:GetLabelObject())
  if g:GetCount() > 0 then
    Duel.SpecialSummon(g,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP_DEFENSE)
  end
  e:SetLabelObject(nil) --Reset before next use
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if a:IsControler(tp) and d:IsControler(1-tp) and a:IsSetCard(0xb01) and a:CanChainAttack() then
		e:SetLabelObject(a)
		return true
	else return false end
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToBattle() then
		Duel.ChainAttack()
	end
end