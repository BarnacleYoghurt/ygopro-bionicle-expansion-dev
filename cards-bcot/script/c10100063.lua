--Matoran Tender Midak
local s,id=GetID()
function s.initial_effect(c)
  --To GY
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
  e1:SetRange(LOCATION_HAND)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetCondition(s.condition1)
  e1:SetCost(s.cost1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --To hand
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(s.target2)
	e2:SetValue(s.value2)
  e2:SetCountLimit(1,{id,1})
  c:RegisterEffect(e2)
end
s.listed_series={0xb01}
function s.filter1a(c)
  return c:IsSetCard(0xb01) and c:IsFaceup() and not c:IsCode(id)
end
function s.filter1b(c)
  return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGrave()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_MZONE,0,1,nil)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() end
  Duel.SendtoGrave(c,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,400)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_DECK,0,1,1,nil)
  if Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
    Duel.Recover(tp,400,REASON_EFFECT)
  end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return (r&REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) and c:GetDestination()==LOCATION_DECK and c:IsAbleToHand() end
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
    Duel.SendtoHand(c,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,c)
    Duel.ShuffleHand(tp)
		return true
	else 
    return false 
  end
end
function s.value2(e,c)
	return false
end
