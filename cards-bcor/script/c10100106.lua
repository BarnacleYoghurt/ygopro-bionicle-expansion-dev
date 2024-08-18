--Manas, Monstrous Crab Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Gain ATK/DEF
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE)
	e1a:SetCode(EFFECT_UPDATE_ATTACK)
	e1a:SetValue(s.value1)
	c:RegisterEffect(e1a)
	local e1b=e1a:Clone()
	e1b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1b)
	--Add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1,{id,1})
	c:RegisterEffect(e3)
end
function s.value1(e)
	return 400*Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSpellTrap),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
end
function s.filter2(c)
	return c:IsSetCard(0xb06) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
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
function s.filter3(c)
	return c:IsSetCard(0xb06) and c:IsOriginalType(TYPE_NORMAL) and c:IsMonsterCard()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp) and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		--Unaffected by other monsters' effects
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3101)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.value3_1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1,true)
		--Return to hand during End Phase
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCondition(s.condition3_2)
		e2:SetOperation(s.operation3_2)
		e2:SetLabelObject(c)
		e2:SetCountLimit(1)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.SpecialSummonComplete()
end
function s.value3_1(e,te)
	return te:IsMonsterEffect() and te:GetOwner()~=e:GetOwner()
end
function s.condition3_2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffect(id)>0 then
		return true
	else
		e:Reset()
		return false
	end
end
function s.operation3_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end