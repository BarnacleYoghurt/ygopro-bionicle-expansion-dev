if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Krana Za, Squad Leader
function c10100211.initial_effect(c)
	--Equip
	local e1=bbts.krana_equip(c)
	c:RegisterEffect(e1)
	--Sacrifice
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100023,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(bbts.krana_condition_equipped)
	e2:SetTarget(c10100211.target2)
	e2:SetValue(1)
	e2:SetOperation(c10100211.operation2)
  e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Revive
	local e3=bbts.krana_revive(c)
	c:RegisterEffect(e3)
end
function c10100211.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec = e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,ec) end
	return Duel.SelectYesNo(tp,aux.Stringid(10100023,3))
end
function c10100211.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ec = e:GetHandler():GetEquipTarget()
	local g = Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,1,ec)
	if g:GetCount() > 0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    Duel.BreakEffect()
    Duel.Draw(tp,1,REASON_EFFECT)
	end
end