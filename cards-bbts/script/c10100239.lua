--Hapaka, Shepherd Rahi
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--DEF gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xb06))
	e1:SetValue(700)
	c:RegisterEffect(e1)
	--Block destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(s.target2)
	e2:SetValue(s.value2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetCondition(s.condition3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
	--To Grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_REMOVE)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation4)
	e4:SetCountLimit(1,id)
	c:RegisterEffect(e4)
end
function s.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter2,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(id,1))
end
function s.value2(e,c)
	return s.filter2(c,e:GetHandlerPlayer())
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.filter3a(c)
	return c:IsFaceup() and c:IsCode(id)
end
function s.filter3b(c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsLevelBelow(4) and c:IsSetCard(0xb06) and c:IsCanChangePosition()
end
function s.condition3(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and not Duel.IsExistingMatchingCard(s.filter3a,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(s.filter3b,tp,LOCATION_MZONE,0,1,nil)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,s.filter3b,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	c:RegisterEffect(e1,true)
end
function s.filter4(c)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:IsAbleToGrave()
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter4,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end