--Infection of the Rahi
function c10100142.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Add Counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100142,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c10100142.condition1)
	e1:SetTarget(c10100142.target1)
	e1:SetOperation(c10100142.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Take control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100142,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10100142.target2)
	e2:SetOperation(c10100142.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Remove Counters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100142,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c10100142.condition3)
	e3:SetTarget(c10100142.target3)
	e3:SetOperation(c10100142.operation3)
	c:RegisterEffect(e3)
end
function c10100142.condition1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if not t then return false end
	if a:IsControler(1-tp) then a,t=t,a end
	return a:IsSetCard(0x15a)
end
function c10100142.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if not t then return false end
	if a:IsControler(1-tp) then a,t=t,a end
	if chk ==0 then	return t:IsCanAddCounter(0x10b2,1) end
	e:SetLabelObject(t)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x10b2)
end
function c10100142.operation1(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetLabelObject()
	if t and t:IsRelateToBattle() and e:GetHandler():IsRelateToEffect(e) and t:AddCounter(0x10b2,1) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		t:RegisterEffect(e1)
	end
end
function c10100142.filter2(c)
	return c:IsAbleToChangeControler() and c:GetCounter(0x10b2)>0
end
function c10100142.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100142.filter2,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c10100142.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c10100142.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local tc=Duel.GetMatchingGroup(c10100142.filter2,tp,0,LOCATION_MZONE,nil)
		if tc and not (Duel.GetControl(tc,tp) or tc:IsImmuneToEffect(e)) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end	
	end
end
function c10100142.filter3a(c)
	return c:GetCounter(0x10b2)>0 and c:IsCanRemoveCounter(tp,0x10b2,c:GetCounter(0x10b2),REASON_EFFECT)
end
function c10100142.filter3b(c)
	return c:GetControler()~=c:GetOwner() and c:IsFaceup()
end
function c10100142.condition3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c10100142.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100142.filter3a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c10100142.filter3a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*400)
end
function c10100142.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10100142.filter3a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	local remct=0
	while tc do
		local cc = tc:GetCounter(0x10b2)
		tc:RemoveCounter(tp,0x10b2,cc,0)
		remct=remct+cc
		tc=g:GetNext()
	end
	Duel.Damage(1-tp,remct*400,REASON_EFFECT)
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c10100142.filter3b,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) then
			tc:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_CONTROL)
			e1:SetValue(tc:GetOwner())
			e1:SetReset(RESET_EVENT+0xec0000)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
