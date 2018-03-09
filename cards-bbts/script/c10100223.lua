--Bohrok Invasion
function c10100223.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c10100223.target0)
	e0:SetOperation(c10100223.operation0)
	c:RegisterEffect(e0)
	--ATK gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c10100223.condition1)
	e1:SetTarget(c10100223.target1)
	e1:SetOperation(c10100223.operation1)
	c:RegisterEffect(e1)
	--DEF gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c10100223.cost2)
	e2:SetTarget(c10100223.target2)
	e2:SetOperation(c10100223.operation2)
	c:RegisterEffect(e2)
end
function c10100223.filter0(c,e,tp)
	return c:IsSetCard(0x15c) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100223.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100223.filter0,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(10100223,0)) then
		e:SetLabel(1)
		local g=Duel.GetMatchingGroup(c10100223.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c10100223.operation0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetLabel()>0 then
		local g=Duel.SelectMatchingCard(tp,c10100223.filter0,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount() > 0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c10100223.filter1(c)
	return c:IsSetCard(0x15c) and c:IsFaceup()
end
function c10100223.condition1(e,tp,eg,ep,ev,re,r,rp)
	local rc=nil
	if re then
		rc=re:GetHandler()
	elseif Duel.GetAttacker() then
		if Duel.GetAttacker():GetControler() == tp then
			rc=Duel.GetAttacker()
		elseif Duel.GetAttackTarget() then
			rc=Duel.GetAttackTarget()
		end
	end
	return rc and eg:IsExists(Card.GetPreviousControler,1,nil,1-tp) and rc:IsSetCard(0x15c)
end
function c10100223.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100223.filter1,tp,LOCATION_MZONE,0,1,nil) end
end
function c10100223.operation1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(400)
	local g=Duel.GetMatchingGroup(c10100223.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterEffect(e1:Clone())
		tc=g:GetNext()
	end
end
function c10100223.filter2(c)
	return c:IsSetCard(0x15c) and c:IsFaceup()
end
function c10100223.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c10100223.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100223.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c10100223.operation2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(800)
	local g=Duel.GetMatchingGroup(c10100223.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterEffect(e1:Clone())
		tc=g:GetNext()
	end
end