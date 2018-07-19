if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bahrag Cahdok, Queen of the Bohrok
function c10100233.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x15c),aux.NonTuner(Card.IsSetCard,0x15c),1)
	c:EnableReviveLimit()
	--Flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c10100233.target1)
	e1:SetOperation(c10100233.operation1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10100233.condition2)
	e2:SetTarget(c10100233.target2)
	e2:SetOperation(c10100233.operation2)
	c:RegisterEffect(e2)
	--Effect Protect
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_FIELD)
	e3a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetTargetRange(LOCATION_MZONE,0)
	e3a:SetCondition(c10100233.condition3)
	e3a:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15e))
	e3a:SetValue(1)
	c:RegisterEffect(e3a)
	local e3b=e3a:Clone()
	e3b:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3b:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e3b)
	--Pendulum
	local e4=bbts.bahrag_pendset(c)
	c:RegisterEffect(e4)
end
function c10100233.filter1(c)
	return c:IsSetCard(0x15c) and c:IsFaceup() and c:IsCanTurnSet()
end
function c10100233.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100233.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c10100233.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10100233.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function c10100233.filter2(c,e,tp)
	return c:IsSetCard(0x15c) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100233.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function c10100233.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100233.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.GetMatchingGroup(c10100233.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100233.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c10100233.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100233.filter3(c)
	return c:IsFaceup() and c:IsCode(10100232)
end
function c10100233.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100233.filter3,tp,LOCATION_ONFIELD,0,1,nil)
end
