--Kane-Ra, Bull Rahi
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Unrespondable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.condition1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--Boost ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--Protection
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_PZONE)		
	e3:SetTargetRange(LOCATION_MZONE,0)	
	e3:SetCondition(s.condition2)
	e3:SetTarget(s.target2)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function s.limit1(e,rp,tp)
	return tp==rp
end
function s.condition1(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_PZONE,0)
	local tc=(g-e:GetHandler()):GetFirst()
	return tc and tc:IsSetCard(0xb06) and tc:IsRace(RACE_BEAST) and tc:IsLevel(7)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local sc=eg:GetFirst()
	while sc do
		if sc:IsSetCard(0xb06) and sc:GetSummonType()==SUMMON_TYPE_PENDULUM then
			Duel.SetChainLimit(s.limit1)
			sc=nil
		else
			sc=eg:GetNext()
		end
	end
end
function s.filter2(c)
	return c:IsSetCard(0xb06) and c:IsFaceup()
end
function s.condition2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==1
end
function s.target2(e,c)
	return c:IsSetCard(0xb06) and c:IsFaceup()
end

