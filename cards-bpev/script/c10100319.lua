if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Nuva Symbol of Flowing Harmony
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --Search EP or Gali
  local e1=bpev.nuva_symbol_search(c,10100002,aux.Stringid(id,2))
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Negate
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,{id,1})
	c:RegisterEffect(e2)
  --Leave field
  local e3=bpev.nuva_symbol_punish(c,nil,s.target3)
  e3:SetDescription(aux.Stringid(id,1))
  c:RegisterEffect(e3)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  if ev<=1 then return false end
  local pc=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):GetHandler()
  local pp=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_CONTROLER)
	return ep==1-tp and pp==tp and pc:IsSetCard(0xb0c) and pc:IsType(TYPE_FUSION) and Duel.IsChainDisablable(ev)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_CARD,0,id)
    local rc=re:GetHandler()
    if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
      Duel.Destroy(rc,REASON_EFFECT)
    end
	end
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetChainLimit(function(e,ep,tp) return ep==1-tp or not e:IsActiveType(TYPE_MONSTER) end)
end