--C.C. Matoran Tamaru
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1a=Effect.CreateEffect(c)
	e1a:SetDescription(aux.Stringid(id,0))
	e1a:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1a:SetProperty(EFFECT_FLAG_DELAY)
	e1a:SetCode(EVENT_SUMMON_SUCCESS)
  e1a:SetRange(LOCATION_GRAVE)
	e1a:SetCondition(s.condition1)
	e1a:SetTarget(s.target1)
	e1a:SetOperation(s.operation1)
	e1a:SetCountLimit(1,id)
	c:RegisterEffect(e1a)
  local e1b=e1a:Clone()
  e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e1b)
	--Swap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id+1000000)
	c:RegisterEffect(e2)
end
function s.filter1(c,tp)
  return c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsSetCard(0xb01)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter1,1,nil,tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function s.filter2(c,e,tp)
	return c:IsLevel(2) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end
