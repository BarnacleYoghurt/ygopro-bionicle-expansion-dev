--Mahi, Goat Rahi
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--Change Levels
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
	--Return 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
function s.filter1(c)
	return c:IsSetCard(0xb06) and c:IsFaceup() and c:HasLevel()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.filter1(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_LVCHANGE,g,#g,tp,1)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_PZONE+LOCATION_EXTRA,0,1,1,nil,RACE_BEAST|RACE_WINGEDBEAST)
		local tg=Duel.GetTargetCards(e)
		if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 and #tg>0 then
			local op=Duel.SelectEffect(tp,
				{true,aux.Stringid(id,3)},
				{tg:FilterCount(Card.IsLevelAbove,nil,2)==#tg,aux.Stringid(id,4)}
			)
			for tc in tg:Iter() do
				if op==1 then
					tc:UpdateLevel(1,RESET_EVENT+RESETS_STANDARD,e:GetHandler())
				elseif op==2 then
					tc:UpdateLevel(-1,RESET_EVENT+RESETS_STANDARD,e:GetHandler())
				end
			end
		end
	end
end
function s.filter2(c)
	return c:IsSetCard(0xb06) and c:IsLevelBelow(4) and c:IsRace(RACE_BEAST|RACE_WINGEDBEAST) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.filter3(c,id)
	return c:IsSetCard(0xb06) and c:GetTurnID()~=id and c:IsAbleToHand()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,LOCATION_REMOVED,0,1,nil,Duel.GetTurnCount()) end
	local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_REMOVED,0,1,1,nil,Duel.GetTurnCount())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
