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
	c:RegisterEffect(e2)
	--Revive
	local e3=bbts.krana_revive(c)
	c:RegisterEffect(e3)
	--Return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c10100211.condition4)
	e4:SetTarget(c10100211.target4)
	e4:SetOperation(c10100211.operation4)
	c:RegisterEffect(e4)
	--Summon
	local e5=bbts.krana_summon(c)
	c:RegisterEffect(e5)
end
function c10100211.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x15c) and c:IsDestructable()
end
function c10100211.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec = e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c10100211.filter2,tp,LOCATION_MZONE,0,1,ec) end
	return Duel.SelectYesNo(tp,aux.Stringid(10100023,3))
end
function c10100211.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ec = e:GetHandler():GetEquipTarget()
	local g = Duel.SelectMatchingCard(tp,c10100211.filter2,tp,LOCATION_MZONE,0,1,1,ec)
	if g:GetCount() > 0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c10100211.filter4(c)
	return c:IsSetCard(0x15c) and c:IsAbleToHand()
end
function c10100211.condition4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10100211.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100211.filter4,tp,LOCATION_GRAVE,0,1,nil) end
	local g = Duel.GetMatchingGroup(c10100211.filter4,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATOHAND,g,1,0,0)
end
function c10100211.operation4(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.SelectMatchingCard(tp,c10100211.filter4,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end