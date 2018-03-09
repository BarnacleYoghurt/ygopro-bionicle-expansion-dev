--Siege of the Rahi
function c10100141.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Flip On Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100141,0))	
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c10100141.target1)
	e1:SetOperation(c10100141.operation1)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	--Destroy self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100141,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10100141.condition2)
	e2:SetTarget(c10100141.target2)
	e2:SetOperation(c10100141.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Substitute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c10100141.target3)
	e3:SetValue(c10100141.value3)
	e3:SetOperation(c10100141.operation3)
	c:RegisterEffect(e3)
end
function c10100141.filter1(c,tp)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:GetSummonPlayer()==1-tp
end
function c10100141.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10100141.filter1,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
end
function c10100141.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c10100141.filter1,nil,tp)
	if g:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) then
		if g:GetCount()>1 then
			g=g:Select(tp,1,1,nil):GetFirst()
		end
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENCE)
	end
end
function c10100141.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x15a) and c:IsLevelAbove(5)
end
function c10100141.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and not Duel.IsExistingMatchingCard(c10100141.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c10100141.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10100141.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c10100141.filter3(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x15a) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsLevelAbove(5)
end
function c10100141.value3(e,c)
	return c10100141.filter3(c,e:GetHandlerPlayer())
end
function c10100141.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10100141.filter3,1,nil,tp) and e:GetHandler():IsAbleToRemove() end
	return Duel.SelectYesNo(tp,aux.Stringid(10100141,2))
end
function c10100141.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end