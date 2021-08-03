if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Toa Mata Kopaka
local s,id=GetID()
function s.initial_effect(c)
  --Tribute from hand
  local e1=bcot.toa_mata_tribute(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
	--Strike bacc & protecc
	local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function s.filter2(c,tp)
  return c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return rp==1-tp and eg:IsExists(s.filter2,1,nil,tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition() end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.ChangePosition(c,POS_FACEUP_DEFENSE) > 0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    if tg:GetCount()>0 then
      Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
    end
  end
  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
  e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
  e1:SetCondition(s.condition2_1)
	e1:SetTarget(s.target2_1)
	e1:SetValue(1)
  e1:SetLabelObject(c)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
  c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function s.condition2_1(e)
  local c=e:GetLabelObject()
  return c:GetFlagEffect(id)~=0 and c:IsPosition(POS_FACEUP_DEFENSE)
end
function s.target2_1(e,c)
  return c~=e:GetHandler()
end