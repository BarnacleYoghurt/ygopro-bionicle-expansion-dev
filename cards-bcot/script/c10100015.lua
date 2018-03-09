--Coming of the Toa
function c10100015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100015,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10100015.target1)
	e1:SetOperation(c10100015.operation1)
	e1:SetCountLimit(1,10100015)
	c:RegisterEffect(e1)
	--On Destroy
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100015,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCost(c10100015.cost2)
	e2:SetCondition(c10100015.condition2)
	e2:SetTarget(c10100015.target2)
	e2:SetOperation(c10100015.operation2)
	e2:SetCountLimit(1,10100015)
	c:RegisterEffect(e2)
end
--e1 - Activate
function c10100015.filter1a(c,tp,id)
	return c:IsReason(REASON_DESTROY) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:GetTurnID()==id
end
function c10100015.filter1b(c,e,tp,ec,g)
	if g and g:IsContains(c) then
		return false
	end
	return c10100015.filter1a(ec,tp,Duel.GetTurnCount()) and c:IsSetCard(0x155) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ec:GetAttribute())
end
function c10100015.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c10100015.filter1a,tp,LOCATION_GRAVE,0,nil,tp,Duel.GetTurnCount())
		local ec=g:GetFirst()
		local sscount=0
		while ec do
			if Duel.IsExistingMatchingCard(c10100015.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,ec,nil) then
				sscount=sscount+1
			end
			ec=g:GetNext()
		end
		return sscount>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0
	end
	local g=Duel.GetMatchingGroup(c10100015.filter1a,tp,LOCATION_GRAVE,0,nil,tp,Duel.GetTurnCount())
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sscount=0
	local ec=g:GetFirst()
	while ec do
		if Duel.IsExistingMatchingCard(c10100015.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,ec,nil) then
			sscount=sscount+1
		end
		ec=g:GetNext()
	end
	if ft>3 then ft=3 end
	if ft>sscount then ft=sscount end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local trg=Duel.SelectTarget(tp,c10100015.filter1a,tp,LOCATION_GRAVE,0,1,ft,nil,tp,Duel.GetTurnCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,trg,trg:GetCount(),0,0)
end
function c10100015.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ssg=Group.FromCards()
	local ec=g:GetFirst()
	while ec do
		if ec:GetPreviousControler()==tp then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local gt=Duel.SelectMatchingCard(tp,c10100015.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,ec,ssg)
			ssg:Merge(gt)
		end
		ec=g:GetNext()
	end
	if ssg:GetCount()~=0 then
		Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP)
		local tc=ssg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:CompleteProcedure()
			tc=ssg:GetNext()
		end
	end
end
--e2 - On Destroy
function c10100015.filter2(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x155) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100015.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp and c:GetPreviousPosition()==POS_FACEDOWN and c:GetLocation()==LOCATION_GRAVE
end
function c10100015.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)>0 end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g,REASON_COST)
end
function c10100015.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100015.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10100015.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPECIAL_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100015.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e)
	if g then
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
