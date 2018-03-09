--Matoran Pilot Kongu
function c10100150.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100150,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c10100150.condition1)
	e1:SetTarget(c10100150.target1)
	e1:SetOperation(c10100150.operation1)
	c:RegisterEffect(e1)
	--Destroy monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100150,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)	
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c10100150.condition2)
	e2:SetTarget(c10100150.target2)
	e2:SetOperation(c10100150.operation2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100150,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c10100150.condition3)
	e3:SetTarget(c10100150.target3)
	e3:SetOperation(c10100150.operation3)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
function c10100150.filter1(c)
	return c:IsRace(RACE_BEAST+RACE_WINDBEAST)
end
function c10100150.condition1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	return not (ec and ec:GetFlagEffect(10100150)~=0)
end
function c10100150.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c10100150.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c10100150.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c10100150.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsRace(RACE_BEAST+RACE_WINDBEAST) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			if Duel.Equip(tp,tc,c,false) then
				--Add Equip limit
				tc:RegisterFlagEffect(10100150,RESET_EVENT+0x1fe0000,0,0)
				e:SetLabelObject(tc)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(c10100150.limit1_1)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SET_AVAILABLE)
				e2:SetCode(EFFECT_DIRECT_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(1)
				tc:RegisterEffect(e2)
			end
		else 
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function c10100150.limit1_1(e,c)
	return e:GetOwner()==c
end
function c10100150.filter2(c,atk)
	return c:IsFaceup() and c:IsDefenseBelow(atk) and c:IsDestructable()
end
function c10100150.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject():GetLabelObject()
	return ec and ec:IsHasCardTarget(e:GetHandler()) and ec:GetFlagEffect(10100150)~=0
end
function c10100150.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetLabelObject():GetLabelObject()
	if chk==0 then return Duel.IsExistingTarget(c10100150.filter2,tp,0,LOCATION_MZONE,1,nil,ec:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10100150.filter2,tp,0,LOCATION_MZONE,1,1,nil,ec:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10100150.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10100150.condition3(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject():GetLabelObject()
	return ec and e:GetHandler():IsReason(REASON_DESTROY) and ec:IsLocation(LOCATION_SZONE) and ec:GetPreviousEquipTarget()==e:GetHandler()
end
function c10100150.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetLabelObject():GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ec and ec:IsReason(REASON_LOST_TARGET) and ec:IsLocation(LOCATION_GRAVE) and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,ec,1,tp,LOCATION_GRAVE)
end
function c10100150.operation3(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject():GetLabelObject()
	if ec and ec:GetPreviousEquipTarget()==e:GetHandler() and ec:IsLocation(LOCATION_GRAVE) then
		Duel.SpecialSummon(ec,0,tp,tp,false,false,POS_FACEUP)
	end
end