--Gift of the Shrine
function c10100051.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DAMAGE_STEP)
	e1:SetTarget(c10100051.target1)
	e1:SetOperation(c10100051.operation1)
	c:RegisterEffect(e1)
end
--e1 - Equip
function c10100051.filter1a(c)
	return c:IsSetCard(0x155) and c:IsType(TYPE_MONSTER)
end
function c10100051.filter1b(c)
	return c:IsCode(10100055) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c10100051.filter1c(c,ec)
	return c:IsSetCard(0x158) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c10100051.filter1d(c)
	return c:IsSetCard(0x158) and c:IsType(TYPE_EQUIP)
end
function c10100051.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c10100051.filter1a,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c10100051.filter1b,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectTarget(tp,c10100051.filter1a,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c10100051.filter1b,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
end
function c10100051.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_EQUIP)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	if g2:GetFirst():IsRelateToEffect(e) and Duel.Remove(g2,POS_FACEUP,REASON_EFFECT) then
		Duel.BreakEffect()
		local tc=g1:GetFirst()
		if Duel.Destroy(tc:GetEquipGroup(), REASON_EFFECT) then
			local g3=Duel.SelectMatchingCard(tp,c10100051.filter1c,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc)
			if g3:GetCount()> 0 then
				Duel.Equip(tp,g3:GetFirst(),tc)
			end
		end
	end
	Duel.Recover(tp,Duel.GetMatchingGroupCount(c10100051.filter1d,tp,LOCATION_GRAVE,0,nil)*800,REASON_EFFECT)
end