--Hapaka, Shepherd Rahi
function c10100239.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Block destruction
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c10100239.target1)
	e1:SetOperation(c10100239.operation1)
	e1:SetValue(c10100239.value1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c10100239.condition2)
	e2:SetOperation(c10100239.operation2)
	c:RegisterEffect(e2)
	--To Grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c10100239.target3)
	e3:SetOperation(c10100239.operation3)
	e3:SetCountLimit(1,10100239)
	c:RegisterEffect(e3)
end
function c10100239.filter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x15a) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c10100239.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10100239.filter1,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(10100239,0))
end
function c10100239.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c10100239.value1(e,c)
	return c10100239.filter1(c,e:GetHandlerPlayer())
end
function c10100239.filter2a(c)
	return c:IsFaceup() and c:IsCode(10100239)
end
function c10100239.filter2b(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsLevelBelow(4) and c:IsSetCard(0x15a) -- and c:IsCanChangePosition()
end
function c10100239.condition2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and not Duel.IsExistingMatchingCard(c10100239.filter2a,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c10100239.filter2b,tp,LOCATION_MZONE,0,1,nil)
end
function c10100239.operation2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c10100239.filter2b,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.ChangePosition(g,POS_FACEUP_DEFENSE) then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x47e0000)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
	end
end
function c10100239.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x15a) and not c:IsCode(10100239) and c:IsAbleToGrave()
end
function c10100239.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100239.filter3,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c10100239.filter3,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c10100239.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10100239.filter3,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
	end
end