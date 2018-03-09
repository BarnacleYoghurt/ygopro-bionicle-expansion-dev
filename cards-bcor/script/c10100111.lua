--Nui-Kopen, Wasp Rahi
function c10100111.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x15a),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Take control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100111,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c10100111.target1)
	e1:SetOperation(c10100111.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end
function c10100111.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15a)
end
function c10100111.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c10100111.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	local g2=Duel.GetMatchingGroup(c10100111.filter1,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,tp,LOCATION_DECK)
end
function c10100111.operation1(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c10100111.filter1,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc	
		end
		tc=g:GetNext()
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	Duel.BreakEffect()
	if spcard:GetAttack()>cc:GetAttack() then
		if cc:IsRelateToEffect(e) and Duel.DiscardDeck(tp,dcount-seq,REASON_EFFECT+REASON_REVEAL) and not Duel.GetControl(cc,tp,PHASE_END,1) then
			if not cc:IsImmuneToEffect(e) and cc:IsAbleToChangeControler() then
				Duel.Destroy(cc,REASON_EFFECT)
			end		
		end
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and spcard:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(spcard,0,tp,tp,false,false,POS_FACEUP)		
		Duel.ShuffleDeck(tp)
	end
end
