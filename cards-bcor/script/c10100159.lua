--Brakas, Monkey Rahi
function c10100159.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Banish and Draw again
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100159,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10100159.condition1)
	e1:SetCost(c10100159.cost1)
	e1:SetTarget(c10100159.target1)
	e1:SetOperation(c10100159.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--To Decktop
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100159,1))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c10100159.target2)
	e2:SetOperation(c10100159.operation2)
	e2:SetCountLimit(1,10100159)
	c:RegisterEffect(e2)	
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100159,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c10100159.target3)
	e3:SetOperation(c10100159.operation3)
	e3:SetCountLimit(1,10100159)
	c:RegisterEffect(e3)
end
function c10100159.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not (tp==Duel.GetTurnPlayer() and Duel.GetCurrentPhase()==PHASE_DRAW)
end
function c10100159.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp and eg:GetCount()>0 and eg:FilterCount(Card.IsLocation,nil,LOCATION_HAND) == eg:GetCount() end
	Duel.Remove(eg,POS_FACEUP,REASON_COST)
end
function c10100159.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10100159.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c10100159.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x15a) end
end
function c10100159.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10100159,3))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x15a)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c10100159.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10100159.operation3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
