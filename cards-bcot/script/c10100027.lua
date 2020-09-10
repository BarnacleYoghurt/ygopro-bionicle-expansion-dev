--Onu-Koro, Village of Earth
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Gain LP
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_FZONE)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Draw
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCondition(s.condition2)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id+1000000)
  c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SUMMON,s.counterfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.filter1(c)
  return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToDeck()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local tg=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE,0,1,5,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount(),0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  if Duel.SendtoDeck(tg,tp,2,REASON_EFFECT)>0 then
    local sc=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
    Duel.Recover(tp,sc*600,REASON_EFFECT)
  end
end
function s.filter2(c)
  return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGraveAsCost()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetLP(tp) > Duel.GetLP(1-tp)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then 
    return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)+Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 
      and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
  
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.target2_1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local dc=math.floor((Duel.GetLP(tp) - Duel.GetLP(1-tp))/1000)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,dc) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(dc)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dc)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
  Duel.SetLP(tp,Duel.GetLP(1-tp))
end
function s.target2_1(e,c)
  return not c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.counterfilter(c)
  return c:IsAttribute(ATTRIBUTE_EARTH)
end