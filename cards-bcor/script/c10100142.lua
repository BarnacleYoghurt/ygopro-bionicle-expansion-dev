--Infection of the Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Add Counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Take control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Remove Counters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if not t then return false end
	if a:IsControler(1-tp) then a,t=t,a end
	return a:IsSetCard(0xb06)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if not t then return false end
	if a:IsControler(1-tp) then a,t=t,a end
	if chk ==0 then	return t:IsCanAddCounter(0x10b2,1) end
	e:SetLabelObject(t)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x10b2)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
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
function s.filter2(c)
	return c:IsAbleToChangeControler() and c:GetCounter(0x10b2)>0
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local tc=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,nil)
		if tc and not (Duel.GetControl(tc,tp) or tc:IsImmuneToEffect(e)) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end	
	end
end
function s.filter3a(c,tp)
	return c:GetCounter(0x10b2)>0 and c:IsCanRemoveCounter(tp,0x10b2,c:GetCounter(0x10b2),REASON_EFFECT)
end
function s.filter3b(c)
	return c:GetControler()~=c:GetOwner() and c:IsFaceup()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter3a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	local g=Duel.GetMatchingGroup(s.filter3a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*400)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter3a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
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
	local g=Duel.GetMatchingGroup(s.filter3b,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) then
			tc:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_CONTROL)
			e1:SetValue(tc:GetOwner())
			e1:SetReset(RESET_EVENT+(RESETS_STANDARD&~(RESET_TOFIELD|RESET_TURN_SET|RESET_TEMP_REMOVE)))
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
