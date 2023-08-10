if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Toa Mata Combination - Crystal
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1b02),6,2)
	c:EnableReviveLimit()
	--Negate/Banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--Tag out
  local e2=bcot.toa_mata_combination_tagout(c,ATTRIBUTE_WATER,ATTRIBUTE_EARTH)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
  aux.DoubleSnareValidity(c,LOCATION_MZONE)
end
s.listed_series={0x1b02}
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  local rc=re:GetHandler()
  local rel=rc:IsRelateToEffect(re)
	if chk==0 then 
    return rc:IsAbleToRemove()
      or (not rel and Duel.IsPlayerCanRemove(tp)) --In case the card banished itself for cost
  end
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
  if rel then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,rc:GetControler(),rc:GetLocation())
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,rc:GetPreviousLocation())
	end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
    Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
  end
end