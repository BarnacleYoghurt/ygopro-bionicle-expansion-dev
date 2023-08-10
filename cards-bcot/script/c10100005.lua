if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Toa Mata Kopaka
local s,id=GetID()
function s.initial_effect(c)
  --Tribute from hand
  local e1=bcot.toa_mata_tribute(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
  --Change position
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetCondition(s.condition2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
  --Attack protection
  local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetCondition(s.condition3)
	e3:SetValue(s.value3)
	c:RegisterEffect(e3)
	--Banish
	local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(id,1))
  e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(s.condition4)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation4)
  e4:SetCountLimit(1)
	c:RegisterEffect(e4)
end
s.listed_series={0x1b02}
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function s.condition3(e)
	return e:GetHandler():IsDefensePos()
end
function s.value3(e,c)
	return not c:IsCode(id)
end
function s.filter4(c,tp)
  return c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
end
function s.condition4(e,tp,eg,ep,ev,re,r,rp)
  return rp==1-tp and eg:IsExists(s.filter4,1,nil,tp)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
  if chk==0 then return g:GetCount()>0 end
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
  if g:GetCount()>0 then
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
  end
end