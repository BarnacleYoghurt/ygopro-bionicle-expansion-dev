--Matoran Trader Ahkmou
local s,id=GetID()
function s.initial_effect(c)
  --Double SS
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Betray
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_CONTROL)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_CHAIN_SOLVED)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
end
s.listed_series={0xb01}
function s.filter1(c,e,tp)
  return c:IsLevelBelow(4) and c:IsSetCard(0xb01) and c:IsCanBeSpecialSummoned(e,tp,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then
    return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
      and Duel.IsPlayerCanSpecialSummonCount(tp,2)
      and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
      and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,c,e,tp)
  end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,LOCATION_HAND,tp)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
    if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsCode(id)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  if chk==0 then return c:GetFlagEffect(id)==0 end
  c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,1-tp)
	end
end