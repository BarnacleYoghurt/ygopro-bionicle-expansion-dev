--...You Wake Them All
local s,id=GetID()
function s.initial_effect(c)
	--Mass Flip
	local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end
function s.filter1(c)
	return c:IsSetCard(0xb08) and c:IsFaceup() and c:IsAbleToHand()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
	local thg=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil)
  local pg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,thg,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,pg,pg:GetCount(),0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
      Duel.BreakEffect()
			Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		end
	end
end
