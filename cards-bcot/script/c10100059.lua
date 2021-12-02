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
  local min=1
  if not eg:IsExists(Card.IsAbleToRemove,1,nil,tp) then min=2 end
  local max=2
  if not Duel.IsChainDisablable(ev) then max=1 end
	if chk==0 then return max>min and e:GetHandler():CheckRemoveOverlayCard(tp,min,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,min,max,REASON_COST)
  local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	if e:GetLabel()>1 then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if e:GetLabel()>1 then
    Duel.NegateEffect(ev)
  end
  Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end