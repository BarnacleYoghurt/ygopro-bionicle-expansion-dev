if not bpev then
  Duel.LoadScript("util-bpev.lua")
end
--Bohrok Gahlok-Kal
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
  --Magnetize
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
  e3:SetCost(Cost.DetachFromSelf(1))
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
s.listed_series={0xb08,0xb09}
function s.filter3(c,tp)
  return c:IsMonster() and (c:IsControler(tp) or c:IsAbleToChangeControler()) and c:CheckUniqueOnField(tp)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
  Duel.SetPossibleOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(3206)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    if Duel.GetTurnPlayer()~=tp then
      e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
    else
      e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
    end
    tc:RegisterEffect(e1)

    local cg=tc:GetColumnGroup()
    if tc:IsInMainMZone() then
      cg=cg+tc:GetColumnGroup(1,1):Filter(Card.IsControler,nil,tc:GetControler()) --Cards in left and right zone only, without the rest of the columns
    end
    cg=cg:Filter(s.filter3,tc,tp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
      local ec=cg:Select(tp,1,1,nil):GetFirst()
      if ec then
        Duel.HintSelection(ec)
        Duel.BreakEffect()
        if Duel.Equip(tp,ec,tc,false) then
          local e2=Effect.CreateEffect(c)
          e2:SetType(EFFECT_TYPE_SINGLE)
          e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
          e2:SetCode(EFFECT_EQUIP_LIMIT)
          e2:SetValue(function(_,c) return c==tc end)
          e2:SetReset(RESET_EVENT+RESETS_STANDARD)
          ec:RegisterEffect(e2)
        end
      end
    end
  end
end
