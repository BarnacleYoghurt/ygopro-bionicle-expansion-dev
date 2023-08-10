if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Nuva Symbol of Deep Wisdom
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --Search EP or Onua
  local e1=bpev.nuva_symbol_search(c,10100003,aux.Stringid(id,3))
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Draw
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCondition(s.condition2)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,{id,1})
  c:RegisterEffect(e2)
  --Leave field
  local e3=bpev.nuva_symbol_punish(c,s.operation3)
  e3:SetDescription(aux.Stringid(id,2))
  c:RegisterEffect(e3)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  local cont,loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION) --Works because condition is checked instantly at triggering EVENT_CHAINING
  return re:IsActiveType(TYPE_FUSION) and re:GetHandler():IsSetCard(0xb0c) and cont==tp and loc==LOCATION_MZONE
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) then
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
  end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
  local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
  if #rg>0 then
    Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
  end
end