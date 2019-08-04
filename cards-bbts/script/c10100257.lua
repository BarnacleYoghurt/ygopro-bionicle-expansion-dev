--Premature Bohrok Beacon
function c10100257.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c10100257.target1)
  e1:SetOperation(c10100257.operation1)
  c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c10100257.condition2)
	c:RegisterEffect(e2)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCondition(aux.exccon)
  e2:SetTarget(c10100257.target2)
  e2:SetOperation(c10100257.operation2)
  e2:SetCountLimit(1,10100257)
  c:RegisterEffect(e2)
end
function c10100257.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.IsExistingTarget(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEDOWN_DEFENSE)
  end
  local g=Duel.SelectTarget(tp,Card.IsPosition,tp,LOCATION_MZONE,0,1,1,nil,POS_FACEDOWN_DEFENSE)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c10100257.operation1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
  end
end
function c10100257.condition2(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c10100257.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then 
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10100257,0x15c,0x11,1400,1400,4,RACE_MACHINE,ATTRIBUTE_DARK) 
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10100257.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10100257,0x15c,0x11,1400,1400,4,RACE_MACHINE,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
		--Fusion material
		local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
    e1:SetValue(c10100257.value2_1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
    --Banish
    local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(LOCATION_REMOVED)
		e2:SetReset(RESET_EVENT+0x47e0000)
    c:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function c10100257.value2_1(e,c)
	return c:IsSetCard(0x15c)
end