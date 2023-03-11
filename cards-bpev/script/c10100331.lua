if not bpev then
	Duel.LoadScript("../util-bpev.lua")
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
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetCost(aux.dxmcostgen(1,1,nil))
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttackBelow,2100),tp,0,LOCATION_MZONE,nil)
  Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  if #rg>0 then
    for tc in rg:Iter() do
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(-500)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD)
      tc:RegisterEffect(e1)
      Duel.AdjustInstantly(tc)
    end
    if c:IsRelateToEffect(e) and rg:FilterCount(Card.IsImmuneToEffect,nil,e)<#rg 
      and Duel.SelectYesNo(tp,aux.Stringid(id,2)) and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
      local dg=rg:Filter(Card.IsAttackBelow,nil,2100)
      Duel.Destroy(dg,REASON_EFFECT)
    end
  end
end