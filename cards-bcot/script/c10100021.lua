--Turaga Nuju
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
  --Protect
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  c:RegisterEffect(e1)
	--Flip/Bounce
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
end
function s.filter0(c)
  return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WARRIOR)
end
function s.check0(g,lc)
  return g:IsExists(s.filter0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_SZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_SZONE,0,1,1,nil)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetCondition(s.condition1_1)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
    tc:RegisterEffect(e1)
  end
end
function s.filter1_1(c)
  return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.condition1_1(e)
  return Duel.IsExistingMatchingCard(s.filter1_1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.filter2(c)
  return c:IsFaceup() and c:IsCanTurnSet()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local fg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,nil)
  local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,fg:GetCount(),nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,fg,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  --Preliminary ruling assumptions based on Vernalizer Fairy and Flower Buds
  -- Need to attempt flipping exactly the number of cards you targeted originally
  -- Getting past the "and if you do" only requires that at least one actually ends up flipped
  -- Only the related cards that are also still valid targets ultimately get bounced
	local g=Duel.GetTargetCards(e):Filter(Card.IsControler,nil,1-tp) --Targets that are still valid and related to the effect
  local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):GetCount() --Original number of targets
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
  local fg=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,0,ct,ct,nil) --also lets you get away with <ct flips if more are impossible - same as Flower Buds
	if Duel.ChangePosition(fg,POS_FACEDOWN_DEFENSE)>0 and fg:IsExists(Card.IsPosition,1,nil,POS_FACEDOWN_DEFENSE) and g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
