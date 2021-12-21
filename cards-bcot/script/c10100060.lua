--Circle of Legends, Amaja-Nui
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
  --Multi-attribute
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.value1)
	c:RegisterEffect(e1)
	--Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
end
function s.check0(g,lc)
  return g:IsExists(Card.IsSetCard,1,nil,0xb03)
end
function s.filter1(c)
  return c:IsType(TYPE_LINK) and c:IsSetCard(0xb03) and c:IsFaceup()
end
function s.value1(e,c)
  local att=0
  local tp=e:GetHandlerPlayer()
  local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  for tc in aux.Next(g) do
    att=att|tc:GetOriginalAttribute()
  end
  return att
end
function s.filter2a(c)
	return c:IsType(TYPE_SPELL+TYPE_EQUIP) and c:IsSetCard(0x2b04) and c:IsAbleToGraveAsCost()
end
function s.filter2b(c,e,tp,att,zone)
	return c:IsRace(RACE_WARRIOR) and c:IsLevelBelow(4) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local att=e:GetHandler():GetAttribute()
  local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then 
    return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 
      and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,att,zone) 
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local att=e:GetHandler():GetAttribute()
  local zone=e:GetHandler():GetLinkedZone(tp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,att,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end