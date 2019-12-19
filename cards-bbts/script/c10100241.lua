--Keras, Crab Rahi
function c10100241.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--ATK up
	local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(10100241,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c10100241.condition1)
  e1:SetTarget(c10100241.target1)
	e1:SetOperation(c10100241.operation1)
	e1:SetCountLimit(1,10100241)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetDescription(aux.Stringid(10100241,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c10100241.target2)
	e2:SetOperation(c10100241.operation2)
	e2:SetCountLimit(1,11100241)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(10100241,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c10100241.target3)
	e3:SetOperation(c10100241.operation3)
	e3:SetCountLimit(1,11100241)
	c:RegisterEffect(e3)
end
function c10100241.condition1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
  local at=Duel.GetAttackTarget()
  if not at then return false end
  if a:IsControler(1-tp) then a=at end
  e:SetLabelObject(a)
  return a:IsControler(tp) and a:IsFaceup() and a:IsAttackBelow(1000)
end
function c10100241.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10100241.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
    local tc=e:GetLabelObject()
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(1400)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end
function c10100241.filter2a(c)
	return c:IsFaceup() and c:IsLevelBelow(4)
end
function c10100241.filter2b(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c10100241.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100241.filter2a,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g = Duel.SelectTarget(tp,c10100241.filter2a,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c10100241.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c10100241.filter2a(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c10100241.filter2b)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c10100241.filter3(c)
  return c:IsFacedown() and c:IsDestructable()
end
function c10100241.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100241.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp,c10100241.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c10100241.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end