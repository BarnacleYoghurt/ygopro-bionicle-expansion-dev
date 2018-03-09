--Toa Mata Combination - Crystal
function c10100059.initial_effect(c)
	aux.AddXyzProcedure(c,c10100059.filter0,6,2)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100059,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10100059.condition1)
	e1:SetCost(c10100059.cost1)
	e1:SetTarget(c10100059.target1)
	e1:SetOperation(c10100059.operation1)
	c:RegisterEffect(e1)
	--Kaita Turbo
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100059,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c10100059.condition2)
	e2:SetCost(c10100059.cost2)
	e2:SetTarget(c10100059.target2)
	e2:SetOperation(c10100059.operation2)
	c:RegisterEffect(e2)
end
--Summon Conditions
function c10100059.filter0(c)
	return c:IsSetCard(0x1155)
end
--e1 - Negate
function c10100059.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainNegatable(ev)
end
function c10100059.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10100059.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c10100059.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--e2 - Kaita Turbo
function c10100059.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1155) and c:GetLevel()==6 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100059.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetOverlayCount()>0
end
function c10100059.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10100059.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPECIAL_SUMMON)
	Duel.SelectTarget(tp,c10100059.filter2,tp,LOCATION_GRAVE,0,1,3,nil,e,tp)
end
function c10100059.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g then
		local tc=g:GetFirst()
		while tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) do	
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_ATTACK)
			e2:SetReset(RESET_EVENT+0xff0000)
			tc:RegisterEffect(e1)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
			tc=g:GetNext()
		end
	end
end