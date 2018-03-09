--Call of the Toa Stones
function c10100053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10100053.target1)
	e1:SetOperation(c10100053.operation1)
	c:RegisterEffect(e1)
end
--e1 - Activate
function c10100053.filter1a(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x155)
end
function c10100053.filter1b(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x158) and c:IsAbleToHand()
end
function c10100053.filter1c(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x155) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100053.filter1d(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x155) and c:IsAbleToHand()
end
function c10100053.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10100053.operation1(e,tp,eg,ep,ev,re,r,rp)
	--No Battle Damage
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Redraw
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,g:GetCount(),REASON_EFFECT)
	local count=Duel.GetMatchingGroupCount(c10100053.filter1a,tp,LOCATION_HAND,0,nil)
	local activated=false
	Duel.BreakEffect()
	--Search Toa
	if count==0 and Duel.IsExistingMatchingCard(c10100053.filter1d,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10100053,0)) then
		local g0a = Duel.SelectMatchingCard(tp,c10100053.filter1d,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g0a, nil, REASON_EFFECT)
		activated=true
	end
	--Free Tribute
	if count>=1 and Duel.SelectYesNo(tp,aux.Stringid(10100053,1)) then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,10100053,0,0x155,0,0,6,RACE_ROCK,ATTRIBUTE_LIGHT) then return end
		c:AddTrapMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_LIGHT,RACE_ROCK,6,0,0)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		c:TrapMonsterBlock()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		activated=true
	end
	--Special Summon Toa
	if count>=2 and Duel.IsExistingMatchingCard(c10100053.filter1c,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(10100053,2)) then
		local g2 = Duel.SelectMatchingCard(tp,c10100053.filter1c,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g2,0,tp,tp,true,false,POS_FACEUP)
		activated=true
	end
	--Search Kanohi
	if count>=3	and Duel.IsExistingMatchingCard(c10100053.filter1b,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10100053,3)) then
		local g3 = Duel.SelectMatchingCard(tp,c10100053.filter1b,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g3, nil, REASON_EFFECT)
		activated=true
	end
	if activated then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
