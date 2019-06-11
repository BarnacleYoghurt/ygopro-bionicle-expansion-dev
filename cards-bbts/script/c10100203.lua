if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Nuhvok
function c10100203.initial_effect(c)
	--flip
  local e1=bbts.bohrok_flip(c)
  c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_TARGET)
	e2:SetTarget(c10100203.target2)
	e2:SetOperation(c10100203.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function c10100203.filter1(c,e,tp)
	return c:IsSetCard(0x15c) and c:GetLevel()==4 and not c:IsCode(10100203) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100203.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10100203.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c10100203.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100203.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c10100203.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10100203.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil) end
	local tg=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c10100203.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetOperation(c10100203.operation2_1)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetLabel(seq)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c10100203.operation2_1(e,tp)
	return bit.lshift(0x1,e:GetLabel()+24)
end