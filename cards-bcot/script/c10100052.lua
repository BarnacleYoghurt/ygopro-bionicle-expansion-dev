if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Golden Great Kanohi
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Copy effects
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_REMOVE)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
  --To hand
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetCost(s.cost3)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
s.listed_series={0xb04,0xb02,0x1b04}
function s.filter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x1b04) and c:IsAbleToRemove()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  local ec=e:GetHandler():GetEquipTarget()
  return ec and ec:IsSetCard(0xb02) and e:GetHandler():GetFlagEffect(id)==0
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=6 end
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,6,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil)
  if c:IsRelateToEffect(e) and g:GetClassCount(Card.GetCode)>=6 then
    local rg=aux.SelectUnselectGroup(g,e,tp,6,6,aux.dncheck,1,tp,HINTMSG_REMOVE)
    if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then
      for rc in aux.Next(rg) do
        c:CopyEffect(rc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
      end
      c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1) --Mark effect as replaced
    end
  end
end
function s.filter3(c)
  return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xb04) and c:IsAbleToGraveAsCost()
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToHand() end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
    if hg:GetCount()>0 then
      Duel.BreakEffect()
      Duel.SendtoDeck(hg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
    end
  end
end