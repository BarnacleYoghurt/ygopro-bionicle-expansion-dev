if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Bohrok Pahrak Va
function s.initial_effect(c)
	--special summon
	local e1 = bbts.bohrokva_selfss(c,10100204)
	c:RegisterEffect(e1)
	--Return to deck
	local e2 = Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TODECK)
  e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Return
	local e3 = bbts.bohrokva_krana(c)
	c:RegisterEffect(e3)
end
function s.filter2(c)
	return c:IsSetCard(0xb08) and c:IsAbleToDeck()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	local g = Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g = Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g:GetFirst(),nil,0,REASON_EFFECT)
	end
end