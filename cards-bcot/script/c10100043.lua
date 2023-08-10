if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Noble Kanohi Komau
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Effect blocker
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
  e2:SetTargetRange(0,LOCATION_MZONE)
  e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	c:RegisterEffect(e2)
	--Recycle
  local e3=bcot.kanohi_revive(c,10100020)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
s.listed_names={10100020}
s.listed_series={0xb04,0xb03,0xb02,0xb07}
function s.filter2(c,atk)
  return c:IsFaceup() and c:GetAttack()<atk
end
function s.condition2(e)
	local tp=e:GetHandlerPlayer()
	return bcot.noblekanohi_con(e) and Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0,nil)>1
end
function s.target2(e,c)
	local tp=e:GetHandlerPlayer()
  return c:IsFaceup() and not Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end