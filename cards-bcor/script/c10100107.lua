--Fikou, Spider Rahi
function c10100107.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100107,0))
	e1:SetCategory(CATEGORY_LVCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c10100107.cost1)
	e1:SetTarget(c10100107.target1)
	e1:SetOperation(c10100107.operation1)
	e1:SetCountLimit(1,10100107)
	c:RegisterEffect(e1)
end
function c10100107.filter1a(c)
	return c:IsFaceup() and c:IsSetCard(0x15a) and c:IsLevelAbove(3)
end
function c10100107.filter1b(c,e,tp)
	return c:IsCode(10100107) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100107.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10100107.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100107.filter1a,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c10100107.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c10100107.filter1a,tp,LOCATION_MZONE,0,1,1,nil)	
	Duel.SetOperationInfo(0,CATEGORY_LVCHANGE,g,1,0,0)	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10100107.operation1(e,tp,eg,ep,ev,re,r,rp)
	local lvc=Duel.GetFirstTarget()
	if lvc and lvc:IsRelateToEffect(e) and c10100107.filter1a(lvc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10100107.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if lvc:RegisterEffect(e1) and g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
