--...You Wake Them All
function c10100226.initial_effect(c)
	--Mass Flip
	local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10100226.target1)
	e1:SetOperation(c10100226.operation1)
	e1:SetCountLimit(1,10100226)
	c:RegisterEffect(e1)
end
function c10100226.filter1(c)
	return c:IsSetCard(0x15c) and c:IsFaceup() and c:IsAbleToHand()
end
function c10100226.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100226.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c10100226.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10100226.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		end
	end
end
