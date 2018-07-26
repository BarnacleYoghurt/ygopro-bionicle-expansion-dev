--As It Was in the Before-Time
function c10100234.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(10100234,0))
	e1:SetTarget(c10100234.target1)
	e1:SetOperation(c10100234.operation1)
	c:RegisterEffect(e1)
	--To grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetDescription(aux.Stringid(10100234,1))
	e2:SetCost(c10100234.cost2)
	e2:SetTarget(c10100234.target2)
	e2:SetOperation(c10100234.operation2)
	c:RegisterEffect(e2)
end
function c10100234.filter1(c)
	return c:IsSetCard(0x15e) and c:IsFaceup() and c:IsDestructable()
end
function c10100234.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100234.filter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	local dmax=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.SelectTarget(tp,c10100234.filter1,tp,LOCATION_ONFIELD,0,1,dmax,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c10100234.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function c10100234.filter2a(c)
	return c:IsSetCard(0x15e) and c:IsFaceup() and c:IsAbleToExtraAsCost()
end
function c10100234.filter2b(c)
	return not (c:IsSetCard(0x15c) or c:IsSetCard(0x15d)) and c:IsAbleToGrave()
end
function c10100234.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10100234.filter2a,tp,LOCATION_ONFIELD,0,nil)
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
function c10100234.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100234.filter2b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c10100234.filter2b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c10100234.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10100234.filter2b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end