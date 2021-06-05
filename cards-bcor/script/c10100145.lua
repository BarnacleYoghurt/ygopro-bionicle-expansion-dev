--Matoran Guard Captain Jaller
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Gain ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xb01))
	e1:SetCondition(s.condition1)
	e1:SetValue(s.value1)
	c:RegisterEffect(e1)	
	--Extra Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xb01))
	c:RegisterEffect(e2)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xb01)
end
function s.value1(e,c)
	return Duel.GetMatchingGroupCount(s.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*400
end
function s.condition1(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end