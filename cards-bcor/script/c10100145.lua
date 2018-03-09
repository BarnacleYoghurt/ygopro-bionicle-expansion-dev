--Matoran Guard Captain Jaller
function c10100145.initial_effect(c)
	c:SetUniqueOnField(1,0,10100145)
	--Gain ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x157))
	e1:SetCondition(c10100145.condition1)
	e1:SetValue(c10100145.value1)
	c:RegisterEffect(e1)	
	--Extra Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x157))
	c:RegisterEffect(e2)
end
function c10100145.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x157)
end
function c10100145.value1(e,c)
	return Duel.GetMatchingGroupCount(c10100145.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*400
end
function c10100145.condition1(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end