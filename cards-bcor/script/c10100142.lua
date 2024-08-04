--Infection of the Rahi
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Add Counter
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1a:SetCode(EVENT_CHAINING)
	e1a:SetRange(LOCATION_SZONE)
	e1a:SetCondition(s.condition1)
	e1a:SetOperation(aux.chainreg)
	c:RegisterEffect(e1a)
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1b:SetCode(EVENT_CHAIN_SOLVED)
	e1b:SetRange(LOCATION_SZONE)
	e1b:SetOperation(s.operation1)
	c:RegisterEffect(e1b)
	--Cannot attack
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD)
	e2a:SetCode(EFFECT_CANNOT_ATTACK)
	e2a:SetRange(LOCATION_SZONE)
	e2a:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2a:SetTarget(function (_,c2) return c2:GetCounter(0x10b2)>0 end)
	c:RegisterEffect(e2a)
	--Damage
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2b:SetCode(EVENT_LEAVE_FIELD_P)
	e2b:SetRange(LOCATION_SZONE)
	e2b:SetOperation(s.operation2b)
	c:RegisterEffect(e2b)
	local e2c=Effect.CreateEffect(c)
	e2c:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2c:SetCode(EVENT_LEAVE_FIELD)
	e2c:SetRange(LOCATION_SZONE)
	e2c:SetCondition(function (e) return e:GetLabelObject():GetLabel()>0 end)
	e2c:SetOperation(s.operation2c)
	e2c:SetLabelObject(e2b)
	c:RegisterEffect(e2c)
	--Take control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e3:SetHintTiming(TIMING_MAIN_END)
	e3:SetCondition(s.condition3)
	e3:SetCost(s.cost3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsMonsterCard()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local c=e:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetCounter(0x10b2)==0 and p~=tp and loc==LOCATION_MZONE and c:GetFlagEffect(1)>0 then
		re:GetHandler():AddCounter(0x10b2,1)
	end
end
function s.filter2(c,p)
	return c:IsLocation(LOCATION_MZONE) and c:GetCounter(0x10b2)>0 and c:GetOwner()==p
end
function s.operation2b(e,tp,eg,ep,ev,re,r,rp)
	local pc=eg:FilterCount(s.filter2,nil,tp)
	local oc=eg:FilterCount(s.filter2,nil,1-tp)
	e:SetLabelObject({pc,oc})
	e:SetLabel(pc+oc)
end
function s.operation2c(e,tp,eg,ep,ev,re,r,rp)
	local pc=e:GetLabelObject():GetLabelObject()[1]
	local oc=e:GetLabelObject():GetLabelObject()[2]
	if pc>0 then
		Duel.Damage(tp,pc*400,REASON_EFFECT)
	end
	if oc>0 then
		Duel.Damage(1-tp,oc*400,REASON_EFFECT)
	end
end
function s.filter3(c)
	return c:IsAbleToChangeControler() and c:GetCounter(0x10b2)>0
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsTurnPlayer(tp) and Duel.IsBattlePhase())
		or (Duel.IsTurnPlayer(1-tp) and Duel.IsMainPhase())
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.filter3,tp,0,LOCATION_MZONE,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local g=Duel.GetMatchingGroup(s.filter3,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,#g,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter3,tp,0,LOCATION_MZONE,nil)
	Duel.GetControl(g,tp,PHASE_END,1)
end	