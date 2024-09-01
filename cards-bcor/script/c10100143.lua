--Rahi Swarm
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--From Grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
function s.filter1a(c,tp)
	return c:IsSetCard(0xb06) and c:IsMonster() and c:IsAbleToHand()
end
function s.filter1b(c,r,code)
	return c:IsSetCard(0xb06) and c:IsAbleToHand() and c:IsRace(r) and not c:IsCode(code)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter1a,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		local race,code=g:GetFirst():GetRace(),g:GetFirst():GetCode()
		if Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK,0,1,nil,race,code) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g:Merge(Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_DECK,0,1,1,nil,race,code))
		end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if #g==2 and g:IsExists(Card.IsType,1,nil,TYPE_EFFECT) then
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
			if #rg>0 then
				Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
function s.filter2a(c,e,tp)
	return c:IsFaceup() and c:IsMonsterCard()
		and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetRace(),c:GetLevel())
end
function s.filter2b(c,e,tp,r,lv)
	return c:IsSetCard(0xb06) and c:IsRace(r) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.filter2a(chkc,e,tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then
		return Duel.IsExistingTarget(s.filter2a,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter2a,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetRace(),tc:GetLevel())
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end