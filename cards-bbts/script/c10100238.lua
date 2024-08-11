if not bcor then
	Duel.LoadScript("util-bcor.lua")
end
--Ghekula, Amphibious Rahi
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--Replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetValue(function (_,c2) return s.filter1b(c2) end)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--To deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
	--Return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1,{id,1})
	c:RegisterEffect(e3)
end
function s.filter1a(c)
	return c:IsRace(RACE_FISH|RACE_SEASERPENT|RACE_AQUA) and c:IsSetCard(0xb06) and c:IsMonsterCard() and not c:IsCode(id)
end
function s.filter1b(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.filter1b,1,nil) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function s.filter2(c)
	return c:IsMonster() and c:IsAbleToDeck()
		and (c:IsLocation(LOCATION_GRAVE) or (c:IsRace(RACE_FISH|RACE_SEASERPENT|RACE_AQUA) and c:IsSetCard(0xb06)))
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return s.filter2(chkc) and (chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp))
			or (chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp))
	end
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_REMOVED,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_REMOVED,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	if g:GetFirst():IsControler(tp) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,1,1-tp,LOCATION_HAND)
	end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK|LOCATION_EXTRA)
			and tc:IsControler(tp) then
			local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
			if #g>0 then
				local rg=g:RandomSelect(tp,1)
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (c:IsAbleToExtra() or bcor.check_rahi_marine_isabletopzone(c,tp))
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local ok=bcor.operation_rahi_marine_return(c,tp,aux.Stringid(id,2),aux.Stringid(id,3))
		if ok then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
			if #g>0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end