--Lightstone
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetCountLimit(1)
	Duel.RegisterEffect(e1,tp)
	local diff=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if diff > 0 then
		if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>2 then
			Duel.SortDecktop(tp,1-tp,3)
		end
		if diff > 1 then
			local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
			if g:GetCount()>0 then
				Duel.ConfirmCards(tp,g)
			end
			if diff > 2 then
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e3:SetCode(EVENT_DRAW)
				e3:SetReset(RESET_PHASE+PHASE_DRAW+RESET_OPPO_TURN)
				e3:SetCondition(s.condition1_3)
				e3:SetOperation(s.operation1_3)
				e3:SetCountLimit(1)
				Duel.RegisterEffect(e3,tp)
			end
		end
	end
end
function s.condition1_3(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and r==REASON_RULE
end	
function s.operation1_3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local fg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if fg:GetCount()>0 then
		Duel.ConfirmCards(tp,fg)
		fg=fg:Filter(Card.IsType,nil,TYPE_MONSTER)
		if fg:GetCount()>0 then
			Duel.Damage(1-tp,fg:GetSum(Card.GetLevel)*200,REASON_EFFECT)		
		end
		Duel.ShuffleHand(1-tp)	
	end
end
