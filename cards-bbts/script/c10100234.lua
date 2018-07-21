--As It Was in the Before-Time
function c10100234.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10100234.cost1)
	e1:SetTarget(c10100234.target1)
	e1:SetOperation(c10100234.operation1)
	c:RegisterEffect(e1)
end
function c10100234.filter1a(c)
	return c:IsSetCard(0x15e) and c:IsFaceup() and c:IsAbleToExtraAsCost()
end
function c10100234.filter1b(c)
	return not (c:IsSetCard(0x15c) or c:IsSetCard(0x15d)) and c:IsDestructable()
end
function c10100234.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10100234.filter1a,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	local cg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		cg:Merge(sg)
	end
	Duel.SendtoDeck(cg,nil,2,REASON_COST)
end
function c10100234.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100234.filter1b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c10100234.filter1b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10100234.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10100234.filter1b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end