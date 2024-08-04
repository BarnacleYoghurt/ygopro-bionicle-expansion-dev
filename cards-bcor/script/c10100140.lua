--Devastation of the Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--From Grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_ONFIELD,0,1,e:GetHandler())
			and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local n=math.min(
		Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_ONFIELD,0,e:GetHandler()),
		Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_ONFIELD,0,1,n,e:GetHandler())
	local ct=Duel.Destroy(g1,REASON_EFFECT)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,ct,ct,nil)
		if #g2>0 then
			Duel.HintSelection(g2,true)
			Duel.SendtoGrave(g2,REASON_EFFECT)
		end
	end
end
function s.filter2a(c)
	return c:IsMonster() and c:IsSetCard(0xb06) and c:IsAbleToRemoveAsCost()
end
function s.filter2b(c)
	return c:IsSetCard(0xb06) and c:IsType(TYPE_SYNCHRO)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
