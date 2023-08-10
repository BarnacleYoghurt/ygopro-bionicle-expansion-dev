if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Toa Mata Lewa
local s,id=GetID()
function s.initial_effect(c)
  --Tribute from hand
  local e1=bcot.toa_mata_tribute(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
	--Bounce
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
end
s.listed_series={0x1b02}
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return (not eg:IsContains(e:GetHandler())) and eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsPreviousControler(tp) 
      and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
      local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
      if g2:GetCount()>0 then
        Duel.BreakEffect()
        Duel.SendtoHand(g2,nil,REASON_EFFECT)
      end
    end
  end
end
    