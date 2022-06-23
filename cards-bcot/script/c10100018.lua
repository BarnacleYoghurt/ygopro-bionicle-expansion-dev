--Turaga Nokama
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
  --Battle protection
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e1:SetCondition(s.condition1)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --Immunize
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCost(s.cost2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
	--To hand
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetHintTiming(TIMING_END_PHASE)
  e3:SetCondition(s.condition3)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,{id,1})
  c:RegisterEffect(e3)
end
function s.filter0(c)
  return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WARRIOR)
end
function s.check0(g,lc)
  return g:IsExists(s.filter0,1,nil)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetLinkedGroupCount()>0
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
  
  local ct=g:GetFirst():GetType()
  ct=bit.band(ct,TYPE_MONSTER)+bit.band(ct,TYPE_SPELL)+bit.band(ct,TYPE_TRAP)
  e:SetLabel(ct)
  
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_DISCARD+REASON_COST)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTarget(s.target2_1)
    e1:SetValue(s.value2_1)
    e1:SetLabel(e:GetLabel())
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
  end
end
function s.target2_1(e,c)
  return e:GetHandler()==c or e:GetHandler():GetLinkedGroup():IsContains(c)
end
function s.value2_1(e,te)
  return bit.band(te:GetActiveType(), e:GetLabel())==0 and te:GetHandler()~=e:GetHandler()
end
function s.filter3(c)
  return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END and e:GetHandler():GetLinkedGroupCount()>0
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return s.filter3(chkc) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) end
  if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SendtoHand(tc,tp,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tc)
  end
end