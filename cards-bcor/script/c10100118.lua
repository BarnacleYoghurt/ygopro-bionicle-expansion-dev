--Mangaia, Lair of Makuta
function c10100118.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c10100118.operation0)
	c:RegisterEffect(e0)
	--Lvl/Rk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100118,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(c10100118.cost1)
	e1:SetTarget(c10100118.target1)
	e1:SetOperation(c10100118.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--No Summon Negation
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15b))
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e2b)
	--No Effect Negation
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c10100118.value3)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetCode(EFFECT_CANNOT_DISABLE)
	e3a:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15b))
	e3a:SetValue(1)
	c:RegisterEffect(e3a)
	--To Hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100118,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(c10100118.target4)
	e4:SetOperation(c10100118.operation4)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(10100118,ACTIVITY_SPSUMMON,c10100118.counterfilter)
end
function c10100118.counterfilter(c)
	return c:IsSetCard(0x15b)
end
function c10100118.filter0(c)
	return bit.band(c:GetType(),0x82)==0x82 or (bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x15b))
end
function c10100118.operation0(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(10100118,2)) then
		local g=Duel.SelectMatchingCard(tp,c10100118.filter0,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c10100118.filter1(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c10100118.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(10100118,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10100118.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c10100118.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x15b)
end
function c10100118.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsExistingMatchingCard(c10100118.filter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c10100118.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local amount=0		
		if Duel.IsPlayerCanDiscardDeck(tp,4) then 
			amount=Duel.AnnounceNumber(tp,1,2,3,4) 
		elseif Duel.IsPlayerCanDiscardDeck(tp,3) then
			amount=Duel.AnnounceNumber(tp,1,2,3)
		elseif Duel.IsPlayerCanDiscardDeck(tp,2) then
			amount=Duel.AnnounceNumber(tp,1,2)
		elseif Duel.IsPlayerCanDiscardDeck(tp,1) then
			amount=1 	
		end
		if amount > 0 and Duel.DiscardDeck(tp,amount,REASON_EFFECT) then
			local g=Duel.GetMatchingGroup(c10100118.filter1,tp,0,LOCATION_MZONE,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				while tc do
					if tc:IsType(TYPE_XYZ) then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_UPDATE_RANK)
						e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
						e1:SetRange(LOCATION_MZONE)
						e1:SetValue(amount)
						e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e1)
						tc=g:GetNext()
					else
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_UPDATE_LEVEL)
						e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
						e1:SetRange(LOCATION_MZONE)
						e1:SetValue(amount)
						e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e1)
						tc=g:GetNext()
					end
				end
			end
		end
	end
end
function c10100118.target1_1(e,c)
	return not c:IsSetCard(0x15b)
end
function c10100118.value3(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsSetCard(0x15b)
end
function c10100118.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_SZONE,0,1,nil) end
	local g = Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10100118.operation4(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount() > 0 and Duel.Destroy(g,REASON_EFFECT) then
		local c=e:GetHandler()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
