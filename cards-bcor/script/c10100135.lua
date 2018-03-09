--Moa, Bird Rahi
function c10100135.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Change Scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100135,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c10100135.cost1)
	e1:SetOperation(c10100135.operation1)
	e1:SetCountLimit(1,10100135)
	c:RegisterEffect(e1)
	--To Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100135,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c10100135.target2)
	e2:SetOperation(c10100135.operation2)
	e2:SetCountLimit(1,11100135)
	c:RegisterEffect(e2)	
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100135,2))
	e3:SetCategory(CATEGORY_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c10100135.target3)
	e3:SetOperation(c10100135.operation3)
	e3:SetCountLimit(1,11100135)
	c:RegisterEffect(e3)
end
function c10100135.filter1a(c)
	return c:IsSetCard(0x15a) and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function c10100135.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100135.filter1a,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100135.filter1a,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount() > 0 then
		e:SetLabelObject(g:GetFirst())
		Duel.Remove(g,POS_FACEUP,nil,REASON_COST)
	end
end
function c10100135.operation1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(e:GetLabelObject():GetLeftScale())
	e1:SetReset(RESET_EVENT+0xdef0000)
	e:GetHandler():RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EFFECT_CHANGE_RSCALE)
	e1a:SetValue(e:GetLabelObject():GetRightScale())
	e:GetHandler():RegisterEffect(e1a)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10100135.target1_2)
	e2:SetOperation(c10100135.operation1_2)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e2)
end
function c10100135.target1_2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10100135.operation1_2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c10100135.filter2(c,id)
	return c:IsFaceup() and c:IsSetCard(0x15a) and c:IsAbleToDeck()
end
function c10100135.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100135.filter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c10100135.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10100135.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
function c10100135.filter3(c,e,tp)
	return c:IsSetCard(0x15a) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100135.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100135.filter3,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10100135.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100135.filter3,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

