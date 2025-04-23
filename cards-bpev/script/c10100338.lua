if not bpev then
  Duel.LoadScript("util-bpev.lua")
end
--Krana Za-Kal, Overseer
local s,id=GetID()
function s.initial_effect(c)
  --Link Summon
  Link.AddProcedure(c,s.filter0,1,1)
  c:EnableReviveLimit()
  --No Link Material
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --ATK/DEF to 0
  local e2a,e2b,e2c=bpev.krana_kal_debuff(c,aux.Stringid(id,1))
  c:RegisterEffect(e2a)
  c:RegisterEffect(e2b)
  c:RegisterEffect(e2c)
  --Negate destruction
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e3:SetCode(EVENT_CHAINING)
  e3:SetCondition(s.condition3)
  e3:SetCost(Cost.Detach(1))
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1)
  c:RegisterEffect(e3)
end
s.listed_series={0xb08,0xb09}
function s.filter0(c)
  return c:IsSetCard(0xb08) or c:IsSetCard(0xb09)
end
function s.filter3(c,tp)
  return c:IsFaceup() and c:IsSetCard(0xb08) and c:IsOnField() and c:IsControler(tp)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
  --A "Bohrok" Spell/Trap that would be negated and destroyed at activation does not count as a card you control!
  if re:IsHasCategory(CATEGORY_NEGATE)
    and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
  local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
  return ex and tg~=nil and tc>(#tg-tg:FilterCount(s.filter3,nil,tp)) --Can activate if number of cards to destroy is greater than number of non-relevant options
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
    Duel.Destroy(eg,REASON_EFFECT)
  end
end