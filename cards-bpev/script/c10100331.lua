if not bpev then
  Duel.LoadScript("util-bpev.lua")
end
--Bohrok Tahnok-Kal
local s,id=GetID()
function s.initial_effect(c)
  Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
  c:EnableReviveLimit()
  --Xyz Material
  Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb08),4,2)
  --Materials to Deck
  local e1=bpev.bohrok_kal_xmat(c)
  c:RegisterEffect(e1)
  --Attach
  local e2=bpev.bohrok_kal_attach(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
  --Thunderbolt and Lightning
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetCost(aux.dxmcostgen(1,1,nil))
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
s.listed_series={0xb08,0xb09}
function s.filter3(c)
  return c:IsFaceup() and c:GetAttack()<2000
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  local g=Duel.GetMatchingGroup(s.filter3,tp,0,LOCATION_MZONE,nil)
  Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(3206)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(3302)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e2:SetCode(EFFECT_CANNOT_TRIGGER)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
  end
  if c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
    local g=Duel.GetMatchingGroup(s.filter3,tp,0,LOCATION_MZONE,nil)
    if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
      Duel.Destroy(g,REASON_EFFECT)
    end
  end
end