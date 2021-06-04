--Infected Kanohi
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)	
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Pay or give control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.condition3)
	e3:SetCost(s.cost3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	--Pay to attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_ATTACK_COST)
	e4:SetCost(s.cost4)
	e4:SetOperation(s.operation4)
	c:RegisterEffect(e4)
	--Return to Hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PREDRAW)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(s.condition5)
	e5:SetTarget(s.target5)
	e5:SetOperation(s.operation5)
	c:RegisterEffect(e5)
end
function s.filter1(c,ex)
	return c:IsFaceup() and c:IsSetCard(0xb04) and c:IsDestructable()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then	
		Duel.Destroy(tc:GetEquipGroup():Filter(s.filter1,c),REASON_EFFECT)		
		Duel.Equip(tp,c,tc)
	end
end
function s.filter3(c)
	return c:IsAbleToGraveAsCost()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local eqt=e:GetHandler():GetEquipTarget()
	return Duel.GetTurnPlayer()==1-tp and eqt and eqt:IsControler(1-tp)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(s.filter3,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler():GetEquipTarget()) and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,s.filter3,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler():GetEquipTarget())
		if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_COST) then
			e:SetLabel(1)		
		end
	end
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local eqt=e:GetHandler():GetEquipTarget()
	if chk==0 then return eqt:IsAbleToChangeControler() end
	if e:GetLabel()==0 then
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,eqt,1,0,0)
	end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if tc and e:GetHandler():IsRelateToEffect(e) and e:GetLabel()==0 then
		if not Duel.GetControl(tc,tp) and not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function s.cost4(e,c,tp)
	return e:GetHandler():GetEquipTarget():IsControler(e:GetHandler():GetControler()) or
	Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler():GetEquipTarget())
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():GetEquipTarget():IsControler(e:GetHandler():GetControler()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler():GetEquipTarget())
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_COST)
      Duel.AttackCostPaid()
		end
  else
      Duel.AttackCostPaid()
	end
end
function s.condition5(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
end
function s.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.operation5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
