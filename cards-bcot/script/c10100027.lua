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
  c:RegisterEffect(e1)
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
