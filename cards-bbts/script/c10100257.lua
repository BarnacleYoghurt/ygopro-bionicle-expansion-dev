--Premature Bohrok Beacon
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_POSITION)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.condition2)
	c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetCondition(aux.exccon)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEDOWN_DEFENSE) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
  local g=Duel.SelectTarget(tp,Card.IsPosition,tp,LOCATION_MZONE,0,1,1,nil,POS_FACEDOWN_DEFENSE)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
  end
end
function s.condition2(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then 
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0xb08,TYPE_MONSTER+TYPE_EFFECT,1400,1400,4,RACE_MACHINE,ATTRIBUTE_DARK) 
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0xb08,TYPE_MONSTER+TYPE_EFFECT,1400,1400,4,RACE_MACHINE,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
		--Fusion material
		local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
    e1:SetValue(s.value3_1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
    --Banish
    local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function s.value3_1(e,c)
	return c:IsSetCard(0xb08)
end