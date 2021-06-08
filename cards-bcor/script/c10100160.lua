--The Drifts of Ko-Wahi
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--On Attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(s.target1)	
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--On Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	--Rescue
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.GetAttacker():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetAttacker() and Duel.GetAttacker():IsRelateToEffect(e) and Duel.GetAttacker():GetFlagEffect(id)==0 then
		local opt=Duel.SelectOption(Duel.GetAttacker():GetControler(),60,61)
		local coin=Duel.TossCoin(Duel.GetAttacker():GetControler(),1)
		if opt==coin and Duel.NegateAttack() then
			Duel.GetAttacker():RegisterFlagEffect(id,RESET_CHAIN,0,1)
		end
	end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsFaceup,1,nil) end
	local g=eg:Filter(Card.IsFaceup,nil)
	local sc = g:GetFirst()
	while sc do
		sc:CreateEffectRelation(e)
		sc=g:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsRelateToEffect,nil,e)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()>0 then
		local roll = Duel.TossDice(g:GetFirst():GetControler(),1)
		local sc = g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(roll*-200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
			if roll == 1 then	
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_EFFECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e3)
				if sc:IsType(TYPE_TRAPMONSTER) then
					local e4=Effect.CreateEffect(e:GetHandler())
					e4:SetType(EFFECT_TYPE_SINGLE)
					e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					sc:RegisterEffect(e4)
				end
			end
			sc=g:GetNext()
		end
	end
end
function s.filter3a(c)
	return c:IsFaceup() and c:IsSetCard(0xb01)
end
function s.filter3b(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb01) and c:IsAbleToHand()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter3a,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.filter3b,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,s.filter3a,tp,LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.GetMatchingGroup(s.filter3b,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
	if g1:GetFirst():IsAttribute(ATTRIBUTE_WATER) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and g2:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,tp,LOCATION_HAND)
	end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,4))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		e:GetHandler():RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		e:GetHandler():RegisterEffect(e2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter3b,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) and tc:IsAttribute(ATTRIBUTE_WATER) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end