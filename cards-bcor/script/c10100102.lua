--Kane-Ra, Bull Rahi
function c10100102.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Unrespondable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10100102.condition1)
	e1:SetOperation(c10100102.operation1)
	c:RegisterEffect(e1)
	--Boost ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c10100102.condition2)
	e2:SetTarget(c10100102.target2)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--Protection
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_PZONE)		
	e3:SetTargetRange(LOCATION_MZONE,0)	
	e3:SetCondition(c10100102.condition2)
	e3:SetTarget(c10100102.target2)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c10100102.limit1(e,rp,tp)
	return tp==rp
end
function c10100102.condition1(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x15a) and tc:IsRace(RACE_BEAST) and tc:GetLevel()==7
end
function c10100102.operation1(e,tp,eg,ep,ev,re,r,rp)
	local sc=eg:GetFirst()
	while sc do
		if sc:IsSetCard(0x15a) and sc:GetSummonType()==SUMMON_TYPE_PENDULUM then
			Duel.SetChainLimit(c10100102.limit1)
			sc=nil
		else
			sc=eg:GetNext()
		end
	end
end
function c10100102.filter2(c)
	return c:IsSetCard(0x15a) and c:IsFaceup()
end
function c10100102.condition2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c10100102.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==1
end
function c10100102.target2(e,c)
	return c:IsSetCard(0x15a) and c:IsFaceup()
end

