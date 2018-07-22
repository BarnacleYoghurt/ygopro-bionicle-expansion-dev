if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Kaita Ja
function c10100229.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCode3(c,10100202,10100205,10100206,true,true)
	c:EnableReviveLimit()
	--Equip Krana
	local e1=bbts.bohrokkaita_krana(c)
	c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c10100229.cost2)
	e2:SetTarget(c10100229.target2)
	e2:SetOperation(c10100229.operation2)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=bbts.bohrokkaita_ss(c)
	c:RegisterEffect(e3)
end
function c10100229.filter2(c)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c10100229.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100229.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c10100229.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10100229.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c10100229.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,2,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end