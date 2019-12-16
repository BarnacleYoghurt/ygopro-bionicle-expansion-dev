--Krana Pit
function c10100256.initial_effect(c)
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
	e1:SetTarget(c10100256.target1)
	e1:SetValue(c10100256.value1)
	e1:SetOperation(c10100256.operation1)
  e1:SetCountLimit(1)
	c:RegisterEffect(e1)
  --To hand
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetDescription(aux.Stringid(10100256,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(c10100256.condition2)
  e2:SetCost(c10100256.cost2)
  e2:SetTarget(c10100256.target2)
  e2:SetOperation(c10100256.operation2)
  e2:SetCountLimit(1,10100256)
  c:RegisterEffect(e2)
end
function c10100256.filter1a(c,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT) 
end
function c10100256.filter1b(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15d) and c:IsAbleToRemove()
end
function c10100256.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
    return eg:IsExists(c10100256.filter1a,1,nil,tp) and Duel.IsExistingMatchingCard(c10100256.filter1b,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) 
  end
	if Duel.SelectYesNo(tp,aux.Stringid(10100256,1)) then
		local g=eg:Filter(c10100256.filter1a,nil,tp)
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
function c10100256.value1(e,c)
	return c==e:GetLabelObject()
end
function c10100256.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c10100256.filter1b,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
  if g:GetCount()>0 then
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
  end
end
function c10100256.filter2a(c)
  return c:IsFaceup() and c:IsSetCard(0x15d)
end
function c10100256.filter2b(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10100256.condition2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c10100256.filter2a,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,nil)
end
function c10100256.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then
    return c:IsAbleToGraveAsCost()
  end
  Duel.SendtoGrave(c,REASON_COST)
end
function c10100256.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingMatchingCard(c10100256.filter2b,tp,LOCATION_REMOVED,0,1,nil)
  end
  local g=Duel.GetMatchingGroup(c10100256.filter2b,tp,LOCATION_REMOVED,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10100256.operation2(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,c10100256.filter2b,tp,LOCATION_REMOVED,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,RESON_EFFECT)
  end
end
