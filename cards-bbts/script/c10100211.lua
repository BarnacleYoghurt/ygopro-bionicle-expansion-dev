if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Krana Za, Squad Leader
function s.initial_effect(c)
	--Equip
	local e1=bbts.krana_equip(c)
	c:RegisterEffect(e1)
	--Sacrifice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(bbts.krana_condition_equipped)
	e2:SetTarget(s.target2)
	e2:SetValue(1)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Revive
	local e3=bbts.krana_revive(c,aux.Stringid(id,3))
	c:RegisterEffect(e3)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec = e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,ec) end
	return Duel.SelectYesNo(tp,aux.Stringid(id,2))
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ec = e:GetHandler():GetEquipTarget()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g = Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,1,ec)
	if g:GetCount() > 0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    Duel.BreakEffect()
    Duel.Draw(tp,1,REASON_EFFECT)
	end
end