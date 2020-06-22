if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Noble Kanohi Huna
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--No attack target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(s.condition2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
  --Recycle
  local e3=bcot.kanohi_revive(c,10100017)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
function s.condition2(e)
  local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1
end