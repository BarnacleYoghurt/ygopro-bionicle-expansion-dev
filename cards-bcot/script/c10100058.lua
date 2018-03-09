--Toa Mata Combination - Storm
function c10100058.initial_effect(c)
	aux.AddXyzProcedure(c,c10100058.filter0,6,2)
	--Detach & Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100058,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10100058.condition1)
	e1:SetTarget(c10100058.target1)
	e1:SetOperation(c10100058.operation1)
	e1:SetCountLimit(1) 
	c:RegisterEffect(e1)
	--Gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c10100058.value2)
	c:RegisterEffect(e2)
end
--Summon Conditions
function c10100058.filter0(c)
	return c:IsSetCard(0x1155)
end
--e1 - Detach & Summon
function c10100058.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1155) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100058.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function c10100058.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10100058.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g1 = e:GetHandler():GetOverlayGroup()
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	local g2 = e:GetHandler():GetOverlayGroup()
	local tc = g1:GetFirst()
	local dc
	while tc do
		if not g2:IsContains(tc) then
			dc = tc
		end
		tc=g1:GetNext()
	end
	if c10100058.filter1(dc,e,tp) then
		Duel.SpecialSummon(dc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100058.operation1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--e2 - Gain ATK
function c10100058.value2(e,c)
	return c:GetOverlayCount()*500
end
