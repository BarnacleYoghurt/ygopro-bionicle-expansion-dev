if not bk then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Kaita Za
function c10100228.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCode3(c,10100201,10100203,10100204,true,true)
	c:EnableReviveLimit()
	--Equip Krana
	local e1=bk.krana(c)
	c:RegisterEffect(e1)
	--Flip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10100228.target2)
	e2:SetOperation(c10100228.operation2)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(c10100228.target3)
	e3:SetOperation(c10100228.operation3)
	c:RegisterEffect(e3)
end
function c10100228.filter2(c)
	return c:IsSetCard(0x15c) and c:IsFacedown()
end
function c10100228.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c10100228.filter2,tp,LOCATION_MZONE,0,1,nil)
	end
end
function c10100228.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c10100228.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount() > 0 then
		Duel.ChangePosition(g,POS_FACEUP)
	end
end
function c10100228.filter3(c,e,tp)
	return c:IsSetCard(0x15c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100228.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c10100228.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local g=Duel.GetMatchingGroup(c10100228.filter3,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100228.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c10100228.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end