--Turaga Nokama
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
	--To hand
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Immunize
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(s.cost2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id+1000000)
  c:RegisterEffect(e2)
end
function s.filter0(c)
  return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WARRIOR)
end
function s.check0(g,lc)
  return g:IsExists(s.filter0,1,nil)
end
function s.filter1(c)
  return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SendtoHand(tc,tp,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tc)
  end
end
function s.filter1(c)
  return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
  e:SetLabel(g:GetFirst():GetType())
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT)
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
  e1:SetReset(RESETS_STANDARD+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
end
function s.target2_1(e,c)
  return e:GetHandler()==c or e:GetHandler():GetLinkedGroup():IsContains(c)
end
function s.value2_1(e,te)
  return bit.band(te:GetActiveType(), e:GetLabel())==0
end