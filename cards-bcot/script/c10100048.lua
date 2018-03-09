--Great Kanohi Aki
function c10100048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10100048.target1)
	e1:SetOperation(c10100048.operation1)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10100048.condition2)
	c:RegisterEffect(e2)
	--Indestructible by battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--ATK gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	--Attack All
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--No damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--Swap
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10100048,0))
	e7:SetCategory(CATEGORY_EQUIP)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCost(c10100048.cost7)
	e7:SetTarget(c10100048.target7)
	e7:SetOperation(c10100048.operation7)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e7)
end
--e1 - Activate
function c10100048.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2155) and not c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x158)
end
function c10100048.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10100048.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10100048.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10100048.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10100048.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--e2 - Equip Limit
function c10100048.condition2(e,c)
	return c:IsSetCard(0x2155)
end
--e7 - Swap
function c10100048.filter7(c,ec)
	return c:IsSetCard(0x158) and c:CheckEquipTarget(ec)
end
function c10100048.cost7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c10100048.target7(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100048.filter7,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e:GetHandler():GetEquipTarget()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10100048.operation7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if Duel.SendtoGrave(c,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c10100048.filter7,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,ec)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),ec)
		end
	end
end
