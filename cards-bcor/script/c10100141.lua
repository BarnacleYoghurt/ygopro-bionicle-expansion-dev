--Siege of the Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Flip On Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))	
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	--Destroy self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Substitute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(s.target3)
	e3:SetValue(s.value3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end
function s.filter1(c,tp)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:GetSummonPlayer()==1-tp
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter1,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter1,nil,tp)
	if g:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) then
		if g:GetCount()>1 then
			g=g:Select(tp,1,1,nil):GetFirst()
		end
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function s.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsLevelAbove(5)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and not Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function s.filter3(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsLevelAbove(5)
end
function s.value3(e,c)
	return s.filter3(c,e:GetHandlerPlayer())
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter3,1,nil,tp) and e:GetHandler():IsAbleToRemove() end
	return Duel.SelectYesNo(tp,aux.Stringid(id,2))
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end