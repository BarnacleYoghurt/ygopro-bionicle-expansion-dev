--Matoran Chronicler Takua
function c10100037.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100037,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c10100037.target1)
	e1:SetOperation(c10100037.operation1)
	c:RegisterEffect(e1)
	--Look & Special Summon
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100037,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10100037.cost2)
	e2:SetTarget(c10100037.target2)
	e2:SetOperation(c10100037.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Battle immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1157))
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
--e1 - Search
function c10100037.filter1(c)
	return c:IsSetCard(0x1157) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10100037.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100037.filter1,tp,LOCATION_DECK,0,1,nil) end
--	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100037.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10100037,2))
	local g=Duel.SelectMatchingCard(tp,c10100037.filter1,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
--e2 - Special Summon
function c10100037.filter2a(c)
	return c:IsSetCard(0x1157) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c10100037.filter2b(c,e,tp)
	return c:IsSetCard(0x1157) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100037.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100037.filter2a,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c10100037.filter2a,1,1,REASON_COST+REASON_DISCARD)
end
function c10100037.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100037.filter2b,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,g,1,0,0)
end
function c10100037.operation2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:FilterCount(c10100037.filter2b,nil,e,tp) then
 		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:FilterSelect(tp,c10100037.filter2b,1,Duel.GetLocationCount(tp,LOCATION_MZONE),nil,e,tp)
	else
		g=g:Filter(c10100037.filter2b,nil,e,tp)
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
