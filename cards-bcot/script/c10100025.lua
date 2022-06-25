--Ta-Koro, Village of Fire
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e1:SetCondition(s.condition1)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	--ATK up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.cost2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
s.listed_attributes={ATTRIBUTE_FIRE}
function s.condition1(e)
  local tp=e:GetHandlerPlayer()
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
  return g:GetCount()>=2 and g:GetCount()==g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
  if not d then return false end  
  if not a:IsControler(tp) then 
    a,d=d,a 
  end
  e:SetLabelObject(a)
  
	return a:IsControler(tp) and d:IsControler(1-tp) and a:IsFaceup() and d:IsFaceup()
    and a:IsAttribute(ATTRIBUTE_FIRE) and a:GetBaseAttack()<d:GetBaseAttack()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_DISCARD+REASON_COST,nil)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
  if e:GetHandler():IsRelateToEffect(e) then
    local a=e:GetLabelObject()
    if a:IsRelateToBattle() and a:IsFaceup() and a:IsControler(tp) then
      local _,atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetBaseAttack)
      
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(atk)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
      a:RegisterEffect(e1)
    end
  end
end