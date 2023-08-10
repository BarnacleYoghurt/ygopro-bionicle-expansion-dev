if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Miru
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Negate targeting effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(s.condition2)
  e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	--Search
  local e3=bcot.kanohi_search(c,10100006)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
s.listed_names={10100006}
s.listed_series={0xb04,0xb02,0xb07}
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not (bcot.greatkanohi_con(e) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler():GetEquipTarget()) and ep~=tp
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end