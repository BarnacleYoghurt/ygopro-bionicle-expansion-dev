--Devastation of the Rahi
function c10100140.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10100140.target1)
	e1:SetOperation(c10100140.operation1)
	e1:SetCountLimit(1,10100140)
	c:RegisterEffect(e1)
	--From Grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100140,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c10100140.cost2)
	e2:SetTarget(c10100140.target2)
	e2:SetOperation(c10100140.operation2)
	e2:SetCountLimit(1,10100140)
	c:RegisterEffect(e2)
end
function c10100140.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x15a) and c:IsDestructable()
end
function c10100140.target1(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then return Duel.IsExistingMatchingCard(c10100140.filter1,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c10100140.filter1,tp,LOCATION_ONFIELD,0,e:GetHandler())
	g:Merge(Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil))
	Duel.SetOperationInfo(1,CATEGORY_DESTROY,g,nil,0,0) 
end
function c10100140.operation1(e,tp,eg,ep,ev,re,r,rp)
	local n=math.min(Duel.GetMatchingGroupCount(c10100140.filter1,tp,LOCATION_ONFIELD,0,e:GetHandler()), Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c10100140.filter1,tp,LOCATION_ONFIELD,0,1,n,e:GetHandler())
	if g1:GetCount()>0 and Duel.Destroy(g1,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,g1:GetCount(),g1:GetCount(),nil)
		if g2:GetCount()>0 then
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end
function c10100140.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15a) and c:IsAbleToRemoveAsCost()
end
function c10100140.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10100140.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100140.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())	
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100140.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c10100140.operation2(e,tp,eg,ep,ev,re,r,rp)	
	local tc=Duel.GetFirstTarget()
	if tc then	
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end	
end
