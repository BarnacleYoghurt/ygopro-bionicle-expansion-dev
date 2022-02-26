--Matoran Tender Kotu
local s,id=GetID()
function s.initial_effect(c)
  --ATK down
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --To hand
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id+1000000)
  c:RegisterEffect(e2)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() or Duel.IsBattlePhase()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,1-tp,LOCATION_MZONE,0,1,nil) end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil):GetMaxGroup(Card.GetAttack)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-800)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end
function s.filter2(c)
  return Duel.IsPlayerCanDraw(c:GetOwner(),1) and c:IsAbleToHand()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter2(chkc) end
  if chk==0 then
    return Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,g:GetFirst():GetOwner(),1)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    if Duel.Draw(tc:GetOwner(),1,REASON_EFFECT)>0 then
      Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
  end
end

