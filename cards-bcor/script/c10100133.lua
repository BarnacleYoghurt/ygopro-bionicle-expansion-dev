--Mahi, Goat Rahi
function c10100133.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--To Grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100133,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c10100133.target1)
	e1:SetOperation(c10100133.operation1)
	e1:SetCountLimit(1,10100133)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100133,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c10100133.target2)
	e2:SetOperation(c10100133.operation2)
	e2:SetCountLimit(1,11100133)
	c:RegisterEffect(e2)	
	--Return 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100133,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c10100133.target3)
	e3:SetOperation(c10100133.operation3)
	e3:SetCountLimit(1,11100133)
	c:RegisterEffect(e3)
end
function c10100133.filter1(c)
	return c:IsSetCard(0x15a) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToGrave()
end
function c10100133.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100133.filter1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c10100133.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c10100133.filter1,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoGrave(g,nil,REASON_EFFECT) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c10100133.filter2(c)
	return c:IsSetCard(0x15a) and c:IsLevelBelow(3) and c:IsAbleToHand()
end
function c10100133.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100133.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100133.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100133.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10100133.filter3(c,id)
	return c:IsSetCard(0x15a) and c:IsLevelBelow(3) and c:GetTurnID()~=id and c:IsAbleToHand()
end
function c10100133.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100133.filter3,tp,LOCATION_REMOVED,0,1,nil,Duel.GetTurnCount()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c10100133.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100133.filter3,tp,LOCATION_REMOVED,0,1,1,nil,Duel.GetTurnCount())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
