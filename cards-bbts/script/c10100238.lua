--Ghekula, Amphibious Rahi
function c10100238.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100238,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c10100238.condition1)
	e1:SetTarget(c10100238.target1)
	e1:SetOperation(c10100238.operation1)
	c:RegisterEffect(e1)
	--SS from Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100238,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c10100238.target2)
	e2:SetOperation(c10100238.operation2)
	e2:SetCountLimit(1,10100238)
	c:RegisterEffect(e2)
	--Invert damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c10100238.condition3)
	e3:SetOperation(c10100238.operation3)
	c:RegisterEffect(e3)
end
function c10100238.condition1(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c10100238.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_SZONE)
end
function c10100238.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100238.filter2(c,e,tp)
	return c:IsSetCard(0x15a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100238.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100238.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c10100238.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_DECK)
end
function c10100238.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c10100238.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
			local sc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e3)
			Duel.Damage(tp,g:GetFirst():GetBaseAttack(),REASON_EFFECT)
		end
	end
end
function c10100238.condition3(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c10100238.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100238,2))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10100238.condition3_1)
	e1:SetTarget(c10100238.target3_1)
	e1:SetOperation(c10100238.operation3_1)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	if not c:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2,true)
	end
end
function c10100238.condition3_1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_EFFECT)~=0
end
function c10100238.target3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c10100238.operation3_1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,ev,REASON_EFFECT) then
		Duel.Damage(1-tp,ev,REASON_EFFECT)
	end
end