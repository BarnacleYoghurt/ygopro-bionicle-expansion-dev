--Turaga Nokama
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
  --Battle protection
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetCondition(s.condition1)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --Immunize
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(s.cost2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
	--To hand
  local e3a=Effect.CreateEffect(c)
  e3a:SetCategory(CATEGORY_TOHAND)
  e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3a:SetCode(EVENT_SUMMON_SUCCESS)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetProperty(EFFECT_FLAG_DELAY)
  e3a:SetCondition(s.condition3)
  e3a:SetTarget(s.target3)
  e3a:SetOperation(s.operation3)
  e3a:SetCountLimit(1,id+1000000)
  c:RegisterEffect(e3a)
  local e3b=e3a:Clone()
  e3b:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e3b)
end
function s.filter0(c)
  return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WARRIOR)
end
function s.check0(g,lc)
  return g:IsExists(s.filter0,1,nil)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetLinkedGroupCount() > 0
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
  
  local ct=g:GetFirst():GetType()
  ct=bit.band(ct,TYPE_MONSTER)+bit.band(ct,TYPE_SPELL)+bit.band(ct,TYPE_TRAP)
  e:SetLabel(ct)
  
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_DISCARD+REASON_COST)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_IMMUNE_EFFECT)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
  e1:SetLabel(e:GetLabel())
  e1:SetTarget(s.target2_1)
  e1:SetValue(s.value2_1)
  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
end
function s.target2_1(e,c)
  return e:GetHandler()==c or e:GetHandler():GetLinkedGroup():IsContains(c)
end
function s.value2_1(e,te)
  return bit.band(te:GetActiveType(), e:GetLabel())==0 and te:GetHandler()~=e:GetHandler()
end
function s.filter3a(c,g)
  return c:IsFaceup() and g:IsContains(c)
end
function s.filter3b(c)
  return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(s.filter3a,1,nil,lg)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(s.filter3b,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,s.filter3b,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SendtoHand(tc,tp,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tc)
  end
end