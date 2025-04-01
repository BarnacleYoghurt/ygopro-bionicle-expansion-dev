--Bohrok Counterattack
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_NEGATE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
end
s.listed_series={0xb08,0xb09}
function s.filter1a(c)
  return c:IsFaceup() and not c:IsSetCard(0xb08)
end
function s.filter1b(c)
  return c:IsSetCard(0xb09) and c:IsAbleToGraveAsCost()
end
function s.filter1c(c,rc,tp)
  return c:IsFaceup() and c:IsSetCard(0xb08) and c:IsType(TYPE_XYZ)
    and rc:IsCanBeXyzMaterial(c,tp,REASON_EFFECT)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and
    Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and
    (Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==0 or Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xb08),tp,LOCATION_MZONE,0,1,nil))
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local rc=re:GetHandler()
  if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and aux.nvfilter(rc) then
    if Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_MZONE,0,1,nil,rc,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
      Duel.BreakEffect()
      rc:CancelToGrave()
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
      local g=Duel.SelectMatchingCard(tp,s.filter1c,tp,LOCATION_MZONE,0,1,1,nil,rc,tp)
      Duel.Overlay(g:GetFirst(),rc,true)
    end
  end
end