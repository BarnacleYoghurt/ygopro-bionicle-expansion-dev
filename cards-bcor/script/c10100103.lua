--Nui-Jaga, Scorpion Rahi
function c10100103.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Indestructible
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10100103.condition1)
	e1:SetTarget(c10100103.target1)
	e1:SetValue(c10100103.value1)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100103,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c10100103.target2)
	e2:SetOperation(c10100103.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function c10100103.value1(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c10100103.condition1(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x15a) and tc:IsRace(RACE_INSECT) and tc:GetLevel()==5
end
function c10100103.target1(e,c)
	return c:GetSequence()>5
end
function c10100103.filter2a(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x15a) and c:IsFaceup() and c:IsAbleToHand()
end
function c10100103.filter2b(c)
	return c:IsDestructable() and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c10100103.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100103.filter2a,tp,LOCATION_EXTRA,0,1,nil) and Duel.IsExistingMatchingCard(c10100103.filter2b,tp,LOCATION_SZONE,0,1,nil) end
	local g1=Duel.GetMatchingGroup(c10100103.filter2a,tp,LOCATION_EXTRA,0,nil)
	local g2=Duel.GetMatchingGroup(c10100103.filter2b,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c10100103.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c10100103.filter2a,tp,LOCATION_EXTRA,0,1,1,nil)
		if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g1)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g2=Duel.SelectMatchingCard(tp,c10100103.filter2b,tp,LOCATION_SZONE,0,1,1,nil)
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end
