--Matoran Astrologer Nixie
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LVCHANGE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Draw + send
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,2))
  e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(s.condition2)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id+1000000)
  c:RegisterEffect(e2)
end
function s.filter1(c)
  return c:IsLevelAbove(2) and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.filter1,1,nil) and ep==tp
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
  eg:GetFirst():CreateEffectRelation(e)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=eg:GetFirst()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_LEVEL)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(-1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    tc:RegisterEffect(e1)
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
  end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function s.filter2(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
  if not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_EFFECT)
  end
end

