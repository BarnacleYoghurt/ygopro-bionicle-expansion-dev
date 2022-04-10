if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Golden Great Kanohi
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,s.filter0a,nil,s.cost0,nil,s.operation0)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --To hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
end
function s.filter0a(c)
	return c:IsFaceup() and c:IsSetCard(0xb02)
end
function s.filter0b(c)
	return c:IsType(TYPE_EQUIP) and (c:IsSetCard(0x1b04) or c:IsSetCard(0x2b04)) and c:IsAbleToRemoveAsCost()
end
function s.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter0b,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,6,6,aux.dncheck,0) end
	local rg=aux.SelectUnselectGroup(g,e,tp,6,6,aux.dncheck,1,tp,HINTMSG_REMOVE)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
  rg:KeepAlive()
  e:SetLabelObject(rg)
end
function s.operation0(e,tp,eg,ep,ev,re,r,rp)  
  local rg=e:GetLabelObject()
  rg=rg:Filter(aux.FilterFaceupFunction(Card.IsLocation,LOCATION_REMOVED),nil)
  for rc in aux.Next(rg) do
    e:GetHandler():CopyEffect(rc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
  end
end
function s.filter2(c)
  return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xb04) and c:IsAbleToGraveAsCost()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToHand() end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) then
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
    if hg:GetCount()>0 then
      Duel.BreakEffect()
      Duel.SendtoDeck(hg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
    end
  end
end