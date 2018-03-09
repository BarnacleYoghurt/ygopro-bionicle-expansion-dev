--Mata Nui Cow, Rahi
function c10100134.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x15a),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Destroy S/T
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100134,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10100134.condition1)
	e1:SetTarget(c10100134.target1)
	e1:SetOperation(c10100134.operation1)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100134,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c10100134.condition2)
	e2:SetTarget(c10100134.target2)
	e2:SetOperation(c10100134.operation2)
	c:RegisterEffect(e2)
end
function c10100134.filter1a(c)
	return c:IsSetCard(0x15a) and c:IsFaceup()
end
function c10100134.filter1b(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10100134.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c10100134.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100134.filter1b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c10100134.filter1b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10100134.operation1(e,tp,eg,ep,ev,re,r,rp)	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c10100134.filter1b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,Duel.GetMatchingGroupCount(c10100134.filter1a,tp,LOCATION_MZONE,0,nil),nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c10100134.filter2(c)
	return c:IsSetCard(0x15a) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c10100134.condition2(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10100134.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100134.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c10100134.filter2,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10100134.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100134.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
