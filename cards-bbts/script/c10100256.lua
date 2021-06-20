--Krana Pit
local s,id=GetID()
function s.initial_effect(c)
  --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(s.target1)
	e1:SetValue(s.value1)
	e1:SetOperation(s.operation1)
  e1:SetCountLimit(1)
	c:RegisterEffect(e1)
  --To hand
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(s.condition2)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
function s.filter1a(c,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT) 
end
function s.filter1b(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb09) and c:IsAbleToRemove()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
    return eg:IsExists(s.filter1a,1,nil,tp) and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) 
  end
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local g=eg:Filter(s.filter1a,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		return true
	else 
    return false 
  end
end
function s.value1(e,c)
	return c==e:GetLabelObject()
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
  if g:GetCount()>0 then
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
  end
end
function s.filter2a(c)
  return c:IsFaceup() and c:IsSetCard(0xb09) and c:IsType(TYPE_MONSTER)
end
function s.filter2b(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,nil)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() end
  Duel.SendtoGrave(c,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_REMOVED,0,1,nil)
  end
  local g=Duel.GetMatchingGroup(s.filter2b,tp,LOCATION_REMOVED,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_REMOVED,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
  end
end
