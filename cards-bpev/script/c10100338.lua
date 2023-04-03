if not bpev then
	Duel.LoadScript("../util-bpev.lua")
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
  local e2a,e2b=bpev.krana_kal_debuff(c)
  c:RegisterEffect(e2a)
  c:RegisterEffect(e2b)
  --Destroy replace
  --Warning: Detaching Za-Kal for this will cause a crash!
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetCode(EFFECT_DESTROY_REPLACE)
  e3:SetCondition(s.condition3)
  e3:SetTarget(s.target3)
  c:RegisterEffect(e3)
end
function s.filter0(c)
  return c:IsSetCard(0xb08) or c:IsSetCard(0xb09)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSetCard(0xb08)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else 
    return false 
  end
end