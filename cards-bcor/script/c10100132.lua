if not bcor then
	Duel.LoadScript("util-bcor.lua")
end
--Lightning Bug, Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=bcor.rahi_insect_spsum(c,s.target1,s.operation1)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end
function s.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb06) and c:IsAbleToRemoveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end -- optional actions do not affect activatability
	Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_MZONE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsNegatableMonster,1-tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
		local g=Duel.SelectMatchingCard(tp,Card.IsNegatableMonster,1-tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			g:GetFirst():NegateEffects(e:GetHandler(),RESET_PHASE+PHASE_END)
		end
	end
end
