--Hoto, Firebug Rahi
function c10100122.initial_effect(c)
	--Destroy S/T
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100122,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10100122.cost1)
	e1:SetTarget(c10100122.target1)
	e1:SetOperation(c10100122.operation1)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,10100122)
	c:RegisterEffect(e1)
end
function c10100122.filter1a(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15a) and c:IsAbleToRemoveAsCost()
end
function c10100122.filter1b(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c10100122.chainlimit1(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c10100122.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10100122.filter1a,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100122.filter1a,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100122.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100122.filter1b,tp,0,LOCATION_ONFIELD,1,nil) end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10100122.filter1b,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetChainLimit(c10100122.chainlimit1(g:GetFirst()))
end
function c10100122.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c10100122.filter1b(tc) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
