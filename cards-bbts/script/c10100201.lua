if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Tahnok
function c10100201.initial_effect(c)
	--flip
  local e1=bbts.bohrok_flip(c)
  c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_TARGET)
	e2:SetCost(c10100201.cost2)
	e2:SetTarget(c10100201.target2)
	e2:SetOperation(c10100201.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function c10100201.filter1(c,e,tp)
	return c:IsSetCard(0x15c) and c:GetLevel()==4 and not c:IsCode(10100201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100201.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10100201.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c10100201.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100201.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c10100201.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10100201.filter2(c)
	return c:IsFaceup() and c:IsDestructable() 
end
function c10100201.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c10100201.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100201.filter2,tp,0,LOCATION_MZONE,1,nil) end
	local tg=Duel.SelectTarget(tp,c10100201.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c10100201.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end