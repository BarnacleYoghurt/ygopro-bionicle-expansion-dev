--Nui-Jaga, Scorpion Rahi
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Indestructible
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_PZONE,0)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.condition1)
	e1:SetTarget(aux.TRUE)
	e1:SetValue(s.value1)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function s.value1(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function s.condition1(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_PZONE,0)
	local tc=(g-e:GetHandler()):GetFirst()
	return tc and tc:IsSetCard(0xb06) and tc:IsRace(RACE_INSECT) and tc:GetLevel()==5
end
function s.filter2a(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xb06) and c:IsFaceup() and c:IsAbleToHand()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_EXTRA,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_SZONE,0,1,nil) end
	local g1=Duel.GetMatchingGroup(s.filter2a,tp,LOCATION_EXTRA,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_PZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_EXTRA,0,1,1,nil)
		if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g1)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g2=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_PZONE,0,1,1,nil)
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end
