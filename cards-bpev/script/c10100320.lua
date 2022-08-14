--Nuva Symbol of Deep Wisdom
local s,id=GetID()
function s.initial_effect(c)
  c:SetUniqueOnField(1,0,id)
  --Activate
  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --Search EP or Onua
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
  --Draw
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCondition(s.condition2)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
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
  return (c:IsSetCard(0xb0b) or c:IsCode(10100003)) and c:IsAbleToHand()
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
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xb0c) 
    and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,10100320),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) then
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
  end
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsFaceup() and not e:GetHandler():IsLocation(LOCATION_DECK)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsFaceup() and chkc:IsCode(10100003) end
  if chk==0 then return true end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,aux.FilterFaceupFunction(Card.IsCode,10100308),tp,LOCATION_ONFIELD,0,1,1,nil)
  if #g>0 then
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
  end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel:GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
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
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
      local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
      if #rg>0 then
        Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
      end
    end
  end
end