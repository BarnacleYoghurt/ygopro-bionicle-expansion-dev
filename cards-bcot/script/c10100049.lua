--Great Kanohi Rua
function c10100049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10100049.target1)
	e1:SetOperation(c10100049.operation1)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10100049.condition2)
	c:RegisterEffect(e2)
	--Immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e3)
	--Piercing Damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--Swap
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10100049,0))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(c10100049.cost5)
	e5:SetTarget(c10100049.target5)
	e5:SetOperation(c10100049.operation5)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e5)
end
--e1 - Equip Limit
function c10100049.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2155) and not c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x158)
end
function c10100049.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10100049.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10100049.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10100049.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10100049.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--e2 - Equip Limit
function c10100049.condition2(e,c)
	return c:IsSetCard(0x2155)
end
--e5 - Swap
function c10100049.filter5(c,ec)
	return c:IsSetCard(0x158) and c:CheckEquipTarget(ec)
end
function c10100049.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c10100049.target5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100049.filter5,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e:GetHandler():GetEquipTarget()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10100049.operation5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if Duel.SendtoGrave(c,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c10100049.filter5,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,ec)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),ec)
		end
	end
end