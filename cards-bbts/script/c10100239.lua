--Hapaka, Shepherd Rahi
function c10100239.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Block destruction
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c10100239.target1)
	e1:SetOperation(c10100239.operation1)
	e1:SetValue(c10100239.value1)
	c:RegisterEffect(e1)
end
function c10100239.filter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x15a) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c10100239.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10100239.filter1,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(10100239,0))
end
function c10100239.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c10100239.value1(e,c)
	return c10100239.filter1(c,e:GetHandlerPlayer())
end