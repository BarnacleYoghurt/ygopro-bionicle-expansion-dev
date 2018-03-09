if not bv then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Pahrak Va
function c10100219.initial_effect(c)
	--special summon
	local e1 = bv.selfss(c,10100204)
	c:RegisterEffect(e1)
	--Return to deck
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10100219.target2)
	e2:SetOperation(c10100219.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Return
	local e3 = bv.krana(c)
	c:RegisterEffect(e3)
end
function c10100219.filter2(c)
	return c:IsSetCard(0x15c) and c:IsAbleToDeck()
end
function c10100219.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100219.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	local g = Duel.GetMatchingGroup(c10100219.filter2,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c10100219.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.SelectMatchingCard(tp,c10100219.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g:GetFirst(),nil,0,REASON_EFFECT)
	end
end