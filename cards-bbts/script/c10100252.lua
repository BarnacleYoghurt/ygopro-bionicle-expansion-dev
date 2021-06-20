--Queens' Illusion
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.cost1)
  e1:SetOperation(s.operation1)
  c:RegisterEffect(e1)
end
function s.filter1a(c,e,tp)
  return c:IsSetCard(0xb0a) and c:IsFacedown() and c:IsType(TYPE_PENDULUM) and Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil):CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,c:GetLevel())
end
function s.filter1b(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb08) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToDeckOrExtraAsCost()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==0
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local g=Duel.SelectMatchingCard(tp,s.filter1a,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    local tc=g:GetFirst()
    Duel.ConfirmCards(1-tp,tc)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil):SelectWithSumEqual(tp,Card.GetLevel,tc:GetLevel(),1,tc:GetLevel())
    Duel.SendtoDeck(sg,nil,2,REASON_COST)
    e:SetLabelObject(tc)
  end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=e:GetLabelObject()
  
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
  e1:SetTarget(aux.TargetBoolFunction(Card.IsAttackBelow,tc:GetAttack()))
  e1:SetValue(aux.imval1)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetTargetRange(0,LOCATION_MZONE)
  e2:SetCode(EFFECT_CANNOT_ATTACK)
  e2:SetTarget(aux.TargetBoolFunction(Card.IsAttackBelow,tc:GetDefense()))
  e2:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e2,tp)
  
  if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
    local fid=tc:GetFieldID()
    if tp==Duel.GetTurnPlayer() then
      tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
    else
      tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,fid)
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetCondition(s.condition1_3)
    e3:SetOperation(s.operation1_3)
    e3:SetLabel(fid)
    e3:SetLabelObject(tc)
    e3:SetCountLimit(1)
    if tp==Duel.GetTurnPlayer() then
      e3:SetReset(RESET_PHASE+PHASE_END)
    else
      e3:SetReset(RESET_PHASE+PHASE_END,2)
    end
    Duel.RegisterEffect(e3,tp)
  end
end
function s.condition1_3(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  return tp==Duel.GetTurnPlayer() and tc:IsFaceup() and tc:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.operation1_3(e,tp,eg,ep,ev,re,r,rp)
  Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
end