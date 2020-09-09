--Turaga Whenua
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
	--LP gain
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_RECOVER)
  e1:SetRange(LOCATION_MZONE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_TO_GRAVE)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  c:RegisterEffect(e1)
  --Search
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
  e2:SetRange(LOCATION_MZONE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
end
function s.filter0(c)
  return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function s.check0(g,lc)
  return g:IsExists(s.filter0,1,nil)
end
function s.filter1(c)
  return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.filter1,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(400)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,400)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end
function s.filter2a(sg,e,tp,mg)
  return sg:FilterCount(s.filter2b,nil,e)==sg:GetCount() and aux.dncheck(sg,e,tp,mg) and Duel.IsExistingMatchingCard(s.filter2c,tp,LOCATION_DECK,0,1,nil,sg)
end
function s.filter2b(c,e)
  return c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e) and c:IsAbleToDeck()
end
function s.filter2c(c,xg)
   return c:IsAbleToHand() and xg:FilterCount(Card.IsCode,nil,c:GetCode())==0
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  local g=Duel.GetMatchingGroup(s.filter2f,tp,LOCATION_GRAVE,0,nil,e)
  if chk==0 then return g:GetClassCount(Card.GetCode)>=3 and aux.SelectUnselectGroup(g,e,tp,3,3,s.filter2a,0,tp,HINTMSG_TODECK) end

  local tg=aux.SelectUnselectGroup(g,e,tp,3,3,s.filter2a,1,tp,HINTMSG_TODECK)
  Duel.SetTargetCard(tg)
  local sg=Duel.GetMatchingGroup(s.filter2c,tp,LOCATION_DECK,0,nil,tg)
  
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,3,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
  local g=Duel.SelectMatchingCard(tp,s.filter2c,tp,LOCATION_DECK,0,1,1,nil,tg)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,tp,REASON_EFFECT)
    Duel.ConfirmCards(1-tp, g)
    Duel.BreakEffect()
    Duel.SendtoDeck(tg,tp,2,REASON_EFFECT)
  end
end