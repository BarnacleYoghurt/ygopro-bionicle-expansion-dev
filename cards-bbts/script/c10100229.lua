if not bbts_bk then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Kaita Ja
function c10100229.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCode3(c,10100202,10100205,10100206,true,true)
	c:EnableReviveLimit()
	--Equip Krana
	local e1=bbts_bk.krana(c)
	c:RegisterEffect(e1)
	--Special Summon A
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10100229.target2)
	e2:SetOperation(c10100229.operation2)
	c:RegisterEffect(e2)
	--Special Summon B
	local e3=bbts_bk.ss(c)
	c:RegisterEffect(e3)
end
function c10100229.filter2(c,e,tp)
	return c:IsSetCard(0x15c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100229.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c10100229.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local g=Duel.GetMatchingGroup(c10100229.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100229.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c10100229.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.ConfirmCards(1-tp,g)
	end
end