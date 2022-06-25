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
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetRange(LOCATION_FZONE)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Draw
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCondition(s.condition2)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,{id,1})
  c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SUMMON,s.counterfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
s.listed_attributes={ATTRIBUTE_EARTH}
function s.counterfilter(c)
  return c:IsAttribute(ATTRIBUTE_EARTH)
end

function s.filter1(c)
  return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToDeck()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local tg=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE,0,1,5,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount(),0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
  if Duel.SendtoDeck(tg,tp,2,REASON_EFFECT)>0 then
    local sc=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
    if sc>0 then
      Duel.BreakEffect()
      Duel.Recover(tp,sc*600,REASON_EFFECT)
    end
  end
end
function s.filter2(c)
  return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGraveAsCost()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)+Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 
      and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
      and Duel.CheckLPCost(tp,1000)
  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
  
  local options={}
  for dc=1,3 do
    if Duel.CheckLPCost(tp,dc*1000) and Duel.IsPlayerCanDraw(tp,dc) then
      table.insert(options,dc*1000)
    end
  end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
  local pay=Duel.AnnounceNumber(tp,table.unpack(options))
  Duel.PayLPCost(tp,pay)
  e:SetLabel(pay/1000)
  
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.target2_1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,3),nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  local dc=e:GetLabel()
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(dc)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dc)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
  if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
    Duel.BreakEffect()
    Duel.DiscardHand(tp,nil,d,d,REASON_EFFECT)
  end
end
function s.target2_1(e,c)
  return not c:IsAttribute(ATTRIBUTE_EARTH)
end