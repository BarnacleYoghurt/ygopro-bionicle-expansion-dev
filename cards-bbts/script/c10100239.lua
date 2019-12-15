--Hapaka, Shepherd Rahi
function c10100239.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--DEF gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15a))
	e1:SetValue(700)
	c:RegisterEffect(e1)
	--Block destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c10100239.target2)
	e2:SetValue(c10100239.value2)
	e2:SetOperation(c10100239.operation2)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetCondition(c10100239.condition3)
	e3:SetOperation(c10100239.operation3)
	c:RegisterEffect(e3)
	--To Grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetDescription(aux.Stringid(10100239,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_REMOVE)
	e4:SetTarget(c10100239.target4)
	e4:SetOperation(c10100239.operation4)
	e4:SetCountLimit(1,10100239)
	c:RegisterEffect(e4)
end
function c10100239.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x15a) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c10100239.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10100239.filter2,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(10100239,1))
end
function c10100239.value2(e,c)
	return c10100239.filter2(c,e:GetHandlerPlayer())
end
function c10100239.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c10100239.filter3a(c)
	return c:IsFaceup() and c:IsCode(10100239)
end
function c10100239.filter3b(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsLevelBelow(4) and c:IsSetCard(0x15a) -- and c:IsCanChangePosition()
end
function c10100239.condition3(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and not Duel.IsExistingMatchingCard(c10100239.filter3a,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c10100239.filter3b,tp,LOCATION_MZONE,0,1,nil)
end
function c10100239.operation3(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c10100239.filter3b,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+0x47e0000)
	c:RegisterEffect(e1,true)
end
function c10100239.filter4(c)
	return c:IsFaceup() and c:IsSetCard(0x15a) and not c:IsCode(10100239) and c:IsAbleToGrave()
end
function c10100239.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100239.filter4,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c10100239.filter4,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c10100239.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10100239.filter4,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
	end
end