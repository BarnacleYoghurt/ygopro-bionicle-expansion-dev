if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Toa Mata Combination - Crystal
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb02),6,2)
	c:EnableReviveLimit()
	--Negate/Banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--Tag out
  local e2=bcot.toa_mata_combination_tagout(c,ATTRIBUTE_WATER,ATTRIBUTE_EARTH)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and (Duel.IsChainDisablable(ev) or eg:IsExists(Card.IsAbleToRemove,1,nil,tp))
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,re:GetHandler():GetLocation())
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,re:GetHandler():GetPreviousLocation())
	end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
    Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
  end
end