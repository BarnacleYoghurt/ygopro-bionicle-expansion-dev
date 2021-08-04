if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Noble Kanohi Matatu
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Direct attack
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(s.condition2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
  --Change damage
  local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetCondition(s.condition3)
	e3:SetValue(aux.ChangeBattleDamage(1,800))
	c:RegisterEffect(e3)
	--Recycle
  local e4=bcot.kanohi_revive(c,10100021)
  e4:SetDescription(aux.Stringid(id,1))
  e4:SetCountLimit(1,id)
  c:RegisterEffect(e4)
end
function s.condition2(e)
  local ec=e:GetHandler():GetEquipTarget()
  local tp=e:GetHandlerPlayer()
	return bcot.noblekanohi_con(e) and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,ec)==0
end
function s.condition3(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end