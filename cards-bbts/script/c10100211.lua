--Krana Za, Squad Leader
function c10100211.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetTarget(c10100211.target1)
	e1:SetOperation(c10100211.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Revive
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(c10100211.condition2)
	e2:SetCost(c10100211.cost2)
	e2:SetTarget(c10100211.target2)
	e2:SetOperation(c10100211.operation2)
	c:RegisterEffect(e2)
	--Return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c10100211.condition3)
	e3:SetTarget(c10100211.target3)
	e3:SetOperation(c10100211.operation3)
	c:RegisterEffect(e3)
	--Summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10100211.condition4)
	e4:SetCost(c10100211.cost4)
	e4:SetTarget(c10100211.target4)
	e4:SetOperation(c10100211.operation4)
	c:RegisterEffect(e4)
end
function c10100211.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x15c) and c:GetLevel()==4
end
function c10100211.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c10100211.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10100211.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10100211.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or not c10100211.filter1(tc) or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(c10100211.value1_1)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100023,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10100211.target1_2)
	e2:SetValue(1)
	e2:SetOperation(c10100211.operation1_2)
	c:RegisterEffect(e2)
end
function c10100211.value1_1(e,c)
	return c==e:GetLabelObject()
end
function c10100211.filter1_2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x15c) and c:IsDestructable()
end
function c10100211.target1_2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec = e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c10100211.filter1_2,tp,LOCATION_MZONE,0,1,ec) end
	return Duel.SelectYesNo(tp,aux.Stringid(10100023,3))
end
function c10100211.operation1_2(e,tp,eg,ep,ev,re,r,rp)
	local ec = e:GetHandler():GetEquipTarget()
	local g = Duel.SelectMatchingCard(tp,c10100211.filter1_2,tp,LOCATION_MZONE,0,1,1,ec)
	if g:GetCount() > 0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c10100211.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsSetCard(0x15c) and rc:IsFaceup() and rc:IsControler(tp)
end
function c10100211.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c10100211.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=eg:GetFirst():GetBattleTarget()
	if chk==0 then return bc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,rc,1,0,0)
end
function c10100211.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
function c10100211.filter3(c)
	return c:IsSetCard(0x15c) and c:IsAbleToHand()
end
function c10100211.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10100211.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100211.filter3,tp,LOCATION_GRAVE,0,1,nil) end
	local g = Duel.GetMatchingGroup(c10100211.filter3,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATOHAND,g,1,0,0)
end
function c10100211.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.SelectMatchingCard(tp,c10100211.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10100211.filter4(c,e,tp)
	return c:IsSetCard(0x15c) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100211.condition4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c10100211.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c10100211.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100211.filter4,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c10100211.filter4,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100211.operation4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c10100211.filter4,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
			Duel.BreakEffect()
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end