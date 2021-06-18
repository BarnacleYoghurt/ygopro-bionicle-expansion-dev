--Beware the Swarm
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end
function s.filter1a(c)
	return c:IsSetCard(0xb08) and c:IsAbleToHand()
end
function s.filter1b(c,lvl)
	return s.filter1a(c) and c:HasLevel() and not c:IsLevel(lvl)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,s.filter1a,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		local ac = g1:GetFirst()
		if ac:IsType(TYPE_MONSTER) then 
			local lvl = ac:GetLevel()
			if Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_GRAVE,0,1,nil,lvl) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_GRAVE,0,1,1,nil,lvl)
				if g2:GetCount()>0 then
					if Duel.SendtoHand(g2,nil,REASON_EFFECT)>0 then
            Duel.ConfirmCards(1-tp,g2)
            local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
            if dg:GetCount()>0 then
              Duel.BreakEffect()
              Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
            end
          end
				end
			end
		end
	end
end
