if not bk then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Kaita Ja
function c10100229.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCode3(c,10100202,10100205,10100206,true,true)
	c:EnableReviveLimit()
	--Equip Krana
	local e1=bk.krana(c)
	c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10100229.condition2)
	e2:SetTarget(c10100229.target2)
	e2:SetOperation(c10100229.operation2)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(c10100229.target3)
	e3:SetOperation(c10100229.operation3)
	c:RegisterEffect(e3)
end
function c10100229.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c10100229.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil)
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c10100229.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c10100229.filter3(c,e,tp)
	return c:IsSetCard(0x15c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100229.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c10100229.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local g=Duel.GetMatchingGroup(c10100229.filter3,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100229.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c10100229.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
