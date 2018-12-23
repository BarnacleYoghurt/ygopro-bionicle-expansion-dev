--Infernavika, Lava Bird Rahi
function c10100235.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Fiyah
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10100235.target1)
	e1:SetOperation(c10100235.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c10100235.target2)
	e2:SetOperation(c10100235.operation2)
	e2:SetCountLimit(1,10100235)
	c:RegisterEffect(e2)
	--To ED
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCost(c10100235.cost3)
	e3:SetTarget(c10100235.target3)
	e3:SetOperation(c10100235.operation3)
	e3:SetCountLimit(1,10100235)
	c:RegisterEffect(e3)
end
function c10100235.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	local g = Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10100235.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1_1 = Effect.CreateEffect(e:GetHandler())
		e1_1:SetCategory(CATEGORY_DESTROY)
		e1_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetCode(EVENT_BATTLE_START)
		e1_1:SetTarget(c10100235.target1_1)
		e1_1:SetOperation(c10100235.operation1_1)
		tc:RegisterEffect(e1_1)
	end
end
function c10100235.filter1_1(c)
	return c:IsDestructable() and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c10100235.target1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	local g = Group.FromCards(c,tc)
	local dg=g:Filter(c10100235.filter1_1,nil)
	if chk==0 then return tc and dg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c10100235.operation1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	local g = Group.FromCards(c,tc)
	local dg=g:Filter(c10100235.filter1_1,nil):Filter(Card.IsRelateToBattle,nil)
	if g:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT) 
	end
end
function c10100235.filter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100235.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100235.filter2,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10100235.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10100235.filter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c10100235.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetDecktopGroup(tp,1)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c10100235.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
end
function c10100235.operation3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoExtraP(e:GetHandler(),nil,REASON_EFFECT)
	end
end