--Sand Tarakava, Lizard Rahi
function c10100108.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Indestructible
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10100108.condition1)
	e1:SetTarget(c10100108.target1)
	e1:SetValue(c10100108.value1)
	c:RegisterEffect(e1)
	--To PZone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100108,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c10100108.target2)
	e2:SetOperation(c10100108.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function c10100108.value1(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c10100108.condition1(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x15a) and tc:IsRace(RACE_REPTILE) and tc:GetLevel()==6
end
function c10100108.target1(e,c)
	return c:GetSequence()>5
end
function c10100108.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x15a) and c:IsType(TYPE_PENDULUM)
end
function c10100108.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) and Duel.IsExistingTarget(c10100108.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c10100108.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10100108.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and c10100108.filter2(tc) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
