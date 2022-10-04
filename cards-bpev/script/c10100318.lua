--Nuva Symbol of Burning Courage
local s,id=GetID()
function s.initial_effect(c)
  c:SetUniqueOnField(1,0,id)
  --Activate
  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --Search EP or Tahu
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_SZONE)
  e1:SetCost(s.cost1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Block effects
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(s.condition2)
	c:RegisterEffect(e2)	
  --Leave field
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,2))
  e3:SetCategory(CATEGORY_REMOVE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetCode(EVENT_LEAVE_FIELD)
  e3:SetCondition(s.condition3)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  c:RegisterEffect(e3)
end
function s.filter1(c)
  return (c:IsSetCard(0xb0b) or c:IsCode(10100001)) and c:IsAbleToHand()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToDeckAsCost() end
  Duel.SendtoDeck(c,nil,LOCATION_DECKBOT,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
  if #g>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
function s.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xb0c) and c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function s.condition2(e)
	local tp=e:GetHandlerPlayer()
  if not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,10100306),tp,LOCATION_ONFIELD,0,1,nil) then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and s.filter2(a,tp)) or (d and s.filter2(d,tp))
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsFaceup() and not e:GetHandler():IsLocation(LOCATION_DECK)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsFaceup() and chkc:IsCode(10100306) end
  if chk==0 then return true end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,aux.FaceupFilter(Card.IsCode,10100306),tp,LOCATION_ONFIELD,0,1,1,nil)
  if #g>0 then
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
  end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel:GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
    Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
    if (not tc:IsImmuneToEffect(e1)) and (not tc:IsImmuneToEffect(e2)) then
      local e3=Effect.CreateEffect(e:GetHandler())
      e3:SetType(EFFECT_TYPE_FIELD)
      e3:SetCode(EFFECT_SKIP_BP)
      e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
      e3:SetTargetRange(1,0)
      if Duel.GetTurnPlayer()==tp then
        e3:SetLabel(Duel.GetTurnCount())
        e3:SetCondition(s.condition3_3)
        e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
      else
        e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
      end
      Duel.RegisterEffect(e3,tp)
    end
  end
end
function s.condition3_3(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end