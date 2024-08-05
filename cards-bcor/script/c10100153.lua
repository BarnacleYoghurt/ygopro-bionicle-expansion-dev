if not bcor then
	Duel.LoadScript("util-bcor.lua")
end
--Cliff Bug, Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=bcor.rahi_insect_spsum(c,nil,s.operation1)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(s.value1_1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end
function s.value1_1(e,te)
	return te:IsActiveType(TYPE_SPELL|TYPE_TRAP)
end
