if not bcor then
	Duel.LoadScript("util-bcor.lua")
end
--Hoto, Firebug Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Destroy S/T
	local e1=bcor.rahi_insect_spsum(c,s.target1,s.operation1)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end -- optional actions do not affect activatability
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsSpellTrap,1-tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsSpellTrap,1-tp,LOCATION_ONFIELD,0,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g,true)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
