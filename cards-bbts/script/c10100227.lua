--Bohrok Swarm Fusion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,0xb08))
	c:RegisterEffect(e1)
  --Shuffle
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCode(EVENT_REMOVE)
  e2:SetCondition(s.condition2)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
function s.filter2(c,tp)
  return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsSetCard(0xb08)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return eg and eg:IsExists(s.filter2,1,nil,tp)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToRemoveAsCost() end
  Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local sg=eg:Filter(s.filter2,nil,tp):Filter(Card.IsAbleToDeck,nil)
  if chk==0 then return sg:GetCount() > 0 and Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local sg=eg:Filter(s.filter2,nil,tp):Filter(Card.IsAbleToDeck,nil)
  local ct=eg:FilterCount(s.filter2,nil,tp)
  if sg:GetCount()>0 and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)==ct then
    if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    Duel.BreakEffect()
    Duel.Draw(tp,1,REASON_EFFECT)
  end
end