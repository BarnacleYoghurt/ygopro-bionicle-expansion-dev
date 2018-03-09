--Taku, Duck Rahi
function c10100128.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100128,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c10100128.condition1)
	e1:SetTarget(c10100128.target1)
	e1:SetOperation(c10100128.operation1)
	c:RegisterEffect(e1)	
	--To Extra Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100128,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c10100128.condition2)
	e2:SetTarget(c10100128.target2)
	e2:SetOperation(c10100128.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Negate Spells
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c10100128.condition3)
	e3:SetOperation(c10100128.operation3)
	c:RegisterEffect(e3)
end
function c10100128.condition1(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c10100128.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_SZONE)
end
function c10100128.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100128.filter2(c)
	return c:IsSetCard(0x15a) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end
function c10100128.condition2(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetTurnPlayer()==tp
end
function c10100128.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100128.filter2,tp,LOCATION_DECK,0,1,nil) end
end
function c10100128.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local g=Duel.SelectMatchingCard(tp,c10100128.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		end
	end
end
function c10100128.condition3(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c10100128.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100128,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCondition(c10100128.condition3_1)
	e1:SetCost(c10100128.cost3_1)
	e1:SetTarget(c10100128.target3_1)
	e1:SetOperation(c10100128.operation3_1)
	c:RegisterEffect(e1)
	if not c:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2,true)
	end
end
function c10100128.filter3_1(c)
	return c:IsSetCard(0x15a) and c:IsAbleToDeck() and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c10100128.condition3_1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c10100128.cost3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100128.filter3_1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10100128.filter3_1,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c10100128.target3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10100128.operation3_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end