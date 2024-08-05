--Infected Kanohi
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Destroy all other Equips
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_EQUIP)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--Pay to attack
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_EQUIP)
	e2a:SetCode(EFFECT_ATTACK_COST)
	e2a:SetCost(s.cost2)
	e2a:SetOperation(s.operation2)
	c:RegisterEffect(e2a)
	--Pay to activate
	local e2b=e2a:Clone()
	e2b:SetType(EFFECT_TYPE_FIELD)
	e2b:SetCode(EFFECT_ACTIVATE_COST)
	e2b:SetRange(LOCATION_SZONE)
	e2b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2b:SetTargetRange(1,1)
	e2b:SetTarget(s.target2)
	c:RegisterEffect(e2b)
	--Pay or give control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.condition3)
	e3:SetCost(s.cost3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	local e3b=Effect.CreateEffect(c)
	e3b:SetType(EFFECT_TYPE_EQUIP)
	e3b:SetCode(EFFECT_SET_CONTROL)
	e3b:SetCondition(function (e) return e:GetHandler():HasFlagEffect(id) end)
	e3b:SetValue(function (e) return e:GetHandlerPlayer() end)
	c:RegisterEffect(e3b)
	--Return to Hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PREDRAW)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(s.condition4)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation4)
	c:RegisterEffect(e4)
end
function s.operation1(e)
	local eqt=e:GetHandler():GetEquipTarget()
	if eqt then
		Duel.Destroy(eqt:GetEquipGroup():Filter(aux.TRUE,e:GetHandler()),REASON_EFFECT)
	end
end
function s.cost2(e,te,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler():GetEquipTarget())
end
function s.target2(e,te,tp)
	return te:GetHandler()==e:GetHandler():GetEquipTarget()
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler():GetEquipTarget())
	if #g>0 then
		Duel.SendtoGrave(g,REASON_COST)
      	Duel.AttackCostPaid()
	else
		Duel.AttackCostPaid(2)
	end
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local eqt=e:GetHandler():GetEquipTarget()
	return Duel.IsTurnPlayer(1-tp) and eqt and eqt:IsControler(1-tp)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	e:GetHandler():ResetFlagEffect(id) -- if we reach this, control must have been returned
	local eqt=e:GetHandler():GetEquipTarget()
	if Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,eqt) and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGraveAsCost,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,eqt)
		if #g>0 and Duel.SendtoGrave(g,REASON_COST,PLAYER_NONE,1-tp)>0 then
			e:SetLabel(1)
		end
	end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1) end
end
function s.condition4(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
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
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
