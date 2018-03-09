--Copper Kanohi of Victory
function c10100056.initial_effect(c)
	--Equip Limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100056,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10100056.target1)
	e1:SetOperation(c10100056.operation1)
	c:RegisterEffect(e1)
	--No destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	--Return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100056,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,10100056)
	e3:SetOperation(c10100056.operation3)
	c:RegisterEffect(e3)
	--Discard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100056,2))
	e4:SetCategory(CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCondition(c10100056.condition4)
	e4:SetOperation(c10100056.operation4)
	c:RegisterEffect(e4)
	--Recycle
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10100056,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,10100056)
	e5:SetTarget(c10100056.target5)
	e5:SetOperation(c10100056.operation5)
	c:RegisterEffect(e5)
	--Search & Victory
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10100056,4))
	e6:SetCategory(CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,10100056)
	e6:SetCondition(c10100056.condition6)
	e6:SetTarget(c10100056.target6)
	e6:SetOperation(c10100056.operation6)
	c:RegisterEffect(e6)
end
--e1 - Equip
function c10100056.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10100056.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--e3 - Return
function c10100056.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT) then
		Duel.ShuffleDeck(tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(1,0)
		e1:SetValue(2)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
--e4 - Discard
function c10100056.condition4(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW and e:GetHandler():IsReason(REASON_DRAW)
end
function c10100056.operation4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
end
--e5 - Recycle
function c10100056.filter5(c)
	return c:IsCode(10100056)
end
function c10100056.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100056.filter5,tp,LOCATION_DECK,0,1,nil) end
end
function c10100056.operation5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100056.filter5,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
--e6 - Search & Victory
function c10100056.filter6(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x158) and not c:IsCode(10100056) and c:IsAbleToGrave()
end
function c10100056.condition6(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function c10100056.target6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local con = Duel.IsExistingMatchingCard(c10100056.filter6,tp,LOCATION_DECK,0,1,nil)
	local op = 1
	if con then
		op = Duel.SelectOption(tp,aux.Stringid(10100056,5),aux.Stringid(10100056,6))
	end
	e:SetLabel(op)
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
	end
end
function c10100056.operation6(e,tp,eg,ep,ev,re,r,rp)
	local op = e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c10100056.filter6,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g1,REASON_EFFECT)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetCondition(c10100056.condition6_1)
		e1:SetTarget(c10100056.target6_1)
		e1:SetOperation(c10100056.operation6_1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10100056.condition6_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsSetCard(0x155) or tc:IsSetCard(0x156) or tc:IsSetCard(0x157) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c10100056.target6_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c10100056.operation6_1(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end