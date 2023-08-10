if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Toa Mata Onua
local s,id=GetID()
function s.initial_effect(c)
  --Tribute from hand
  local e1=bcot.toa_mata_tribute(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
  --Recycle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
end
s.listed_series={0x1b02}
function s.filter2(c)
  return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.filter2,1,nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsAbleToDeck() and chkc:IsLocation(LOCATION_GRAVE) end
  if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
  local tg=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    --Calculate LP gain while target is still in GY
    local lpg=0
    if tc:IsType(TYPE_MONSTER) and tc:IsAttackAbove(0) then --no function for checking for ? original ATK, so we'll just have to assume there's no GY ATK modification
      lpg=e:GetHandler():GetAttack()-tc:GetBaseAttack()
    end
    --Return to Deck
    if tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0 then
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		else
			Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
		end
    --Apply LP gain
    if lpg>0 then
      Duel.Recover(tp,lpg,REASON_EFFECT)
    end
  end
end