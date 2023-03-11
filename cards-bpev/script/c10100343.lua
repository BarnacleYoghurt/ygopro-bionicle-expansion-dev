if not bpev then
	Duel.LoadScript("../util-bpev.lua")
end
--Krana Su-Kal, Demolisher
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
  local e2a,e2b=bpev.krana_kal_debuff(c)
  c:RegisterEffect(e2a)
  c:RegisterEffect(e2b)
  --ATK/DEF buff
  local e3a=Effect.CreateEffect(c)
  e3a:SetType(EFFECT_TYPE_XMATERIAL)
  e3a:SetRange(LOCATION_MZONE)
  e3a:SetCode(EFFECT_UPDATE_ATTACK)
  e3a:SetCondition(s.condition3)
  e3a:SetValue(800)
  c:RegisterEffect(e3a)
  local e3b=e3a:Clone()
  e3b:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e3b)
  --Protection
  local e3c=Effect.CreateEffect(c)
  e3c:SetType(EFFECT_TYPE_XMATERIAL)
  e3c:SetRange(LOCATION_MZONE)
  e3c:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e3c:SetCondition(s.condition3)
  e3c:SetValue(1)
  c:RegisterEffect(e3c)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSetCard(0xb08)
end
