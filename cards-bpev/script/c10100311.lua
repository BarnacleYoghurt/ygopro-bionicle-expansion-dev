if not bpev then
  Duel.LoadScript("util-bpev.lua")
end
--Toa Nuva Lewa
local s,id=GetID()
function s.initial_effect(c)
  c:EnableReviveLimit() 
  --Fusion Material
  Fusion.AddProcMix(c,true,true,10100006,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb0b))
  --Add Spell/Trap
  local e1=bpev.toa_nuva_search(c)
  e1:SetDescription(aux.Stringid(id,0))
  c:RegisterEffect(e1)
  --Bounce
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetHintTiming(TIMING_MAIN_END)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
s.material_setcode={0xb02,0x1b02,0xb0b}
s.listed_series={0xb0b,0xb0c}
s.listed_names={10100006}
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsMainPhase()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
  Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_EITHER,LOCATION_MZONE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsPreviousControler(tp)
      and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
      local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
      if #g2>0 then
        Duel.BreakEffect()
        Duel.SendtoHand(g2,nil,REASON_EFFECT)
      end
    end
  end
end