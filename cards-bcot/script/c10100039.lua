--Turaga Nui
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot SS by other ways
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--Special Summon Warrior
	local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.cost1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--Special Summon and negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,{id,1})
	c:RegisterEffect(e2)
end
s.listed_series={0x2b04,0xb03}
function s.filter1a(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x2b04) and c:IsAbleToGraveAsCost()
end
function s.filter1b(c,e,tp)
  return c:IsType(TYPE_LINK) and c:IsSetCard(0xb03) and c:IsFacedown() and Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetAttribute())
end
function s.filter1c(c,e,tp,att)
  return c:IsLevelBelow(4) and c:IsRace(RACE_WARRIOR) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter1a,tp,LOCATION_DECK,0,1,1,nil)
  g:AddCard(c)
  Duel.SendtoGrave(g,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local rg=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if rg:GetCount()>0 then
    Duel.ConfirmCards(1-tp,rg)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
      local att=rg:GetFirst():GetAttribute()
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local sg=Duel.SelectMatchingCard(tp,s.filter1c,tp,LOCATION_HAND,0,1,1,nil,e,tp,att)
      Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end
function s.filter2(c)
  return c:IsSetCard(0xb03) and c:IsType(TYPE_LINK)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=6
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then 
      return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true) 
        and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) 
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
    for tc in aux.Next(g) do
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_DISABLE)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD)
      tc:RegisterEffect(e1)
      local e2=Effect.CreateEffect(c)
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_DISABLE_EFFECT)
      e2:SetReset(RESET_EVENT+RESETS_STANDARD)
      tc:RegisterEffect(e2)
    end
  end
end