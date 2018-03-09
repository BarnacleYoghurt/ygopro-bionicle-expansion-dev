--Noble Kanohi Ruru
function c10100042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10100042.target1)
	e1:SetOperation(c10100042.operation1)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10100042.condition2)
	c:RegisterEffect(e2)
	--Confirm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100042,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10100042.condition3)
	e3:SetOperation(c10100042.operation3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetCode(EVENT_SPSUMMON_SUCCESS)
	--Swap
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100042,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c10100042.cost4)
	e4:SetTarget(c10100042.target4)
	e4:SetOperation(c10100042.operation4)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
end
--e1 - Activate
function c10100042.filter1(c)
	return c:IsFaceup() and (c:IsSetCard(0x155) or c:IsSetCard(0x156)) and not c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x158)
end
function c10100042.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10100042.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10100042.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10100042.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10100042.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--e2 - Equip Limit
function c10100042.condition2(e,c)
	return c:IsSetCard(0x155) or c:IsSetCard(0x156)
end
--e3 - Confirm
function c10100042.condition3(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsFacedown,1-tp,LOCATION_ONFIELD,0,2,nil)
end
function c10100042.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.ConfirmCards(tp,g)
end
--e4 - Swap
function c10100042.filter4(c,ec)
	return c:IsSetCard(0x158) and c:CheckEquipTarget(ec)
end
function c10100042.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c10100042.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100042.filter4,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e:GetHandler():GetEquipTarget()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10100042.operation4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if Duel.SendtoGrave(c,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c10100042.filter4,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,ec)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),ec)
		end
	end
end