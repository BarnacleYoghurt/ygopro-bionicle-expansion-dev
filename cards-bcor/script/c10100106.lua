--Manas, Monstrous Crab Rahi
local s,id=GetID()
function s.initial_effect(c)
	--No Targeting or Destruction
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1a:SetValue(s.value1a)
	c:RegisterEffect(e1a)
	--Gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--To Hand
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end
function s.value1a(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) 
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(800)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end