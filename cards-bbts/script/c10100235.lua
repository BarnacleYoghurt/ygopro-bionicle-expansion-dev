--Infernavika, Lava Bird Rahi
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--Fiyah
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
	--To ED
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCost(s.cost3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local e1 = Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetTarget(s.target1_1)
		e1:SetOperation(s.operation1_1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.filter1_1(c)
	return c:IsDestructable() and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.target1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	local g = Group.FromCards(c,tc)
	local dg=g:Filter(s.filter1_1,nil)
	if chk==0 then return tc and dg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function s.operation1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	local g = Group.FromCards(c,tc)
	local dg=g:Filter(s.filter1_1,nil):Filter(Card.IsRelateToBattle,nil)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT) 
	end
end
function s.filter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.FaceupFilter(Card.IsSetCard,0xb06),tp,LOCATION_MZONE,0,1,1,nil)
	g:Merge(Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.filter3(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST|RACE_WINGEDBEAST) and c:IsSetCard(0xb06)
		and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:IsExists(Card.IsAbleToRemoveAsCost,1,nil) end
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_REMOVED)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end