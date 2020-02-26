--Ta-Koro, Village of Fire
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Protection
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD)
	e1a:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1a:SetRange(LOCATION_SZONE)
	e1a:SetTargetRange(LOCATION_MZONE,0)
  e1a:SetCondition(s.condition1)
	e1a:SetValue(aux.tgoval)
	c:RegisterEffect(e1a)
  local e1b=e1a:Clone()
  e1b:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  c:RegisterEffect(e1b)
	--ATK up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.cost2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
function s.filter1(c)
  return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.condition1(e)
  local tp=e:GetHandlerPlayer()
  return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=2 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_MZONE,0,nil,ATTRIBUTE_FIRE)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
  if a:GetControler()~=tp then
    local s=a
    a=d
    d=s
  end
  
	return a and d 
    and a:GetControler()==tp and d:GetControler()~=tp 
    and a:IsFaceup() and d:IsFaceup()
    and a:IsAttribute(ATTRIBUTE_FIRE) and a:IsRelateToBattle() and a:GetBaseAttack()<d:GetBaseAttack()
end
function c10100025.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST,nil)
end
function c10100025.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
  if a:GetControler()~=tp then
    local s=a
    a=d
    d=s
  end
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
  
  local _,atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetBaseAttack)
  
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(atk)
  a:RegisterEffect(e1)
end