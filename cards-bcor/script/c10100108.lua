--Sand Tarakava, Lizard Rahi
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
	--To PZone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
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
	return tc and tc:IsSetCard(0xb06) and tc:IsRace(RACE_REPTILE) and tc:GetLevel()==6
end
function s.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsType(TYPE_PENDULUM)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and s.filter2(tc) then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
