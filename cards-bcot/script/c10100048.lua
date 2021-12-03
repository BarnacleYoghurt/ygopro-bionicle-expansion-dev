if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Great Kanohi Aki
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Indestructible by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetCondition(s.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--ATK gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetCondition(s.condition)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
  --Piercing
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_EQUIP)
  e4:SetCode(EFFECT_PIERCE)
  e4:SetCondition(s.condition)
  c:RegisterEffect(e4)
  --Attack All
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_ATTACK_ALL)
  e5:SetCondition(s.condition)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Equip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(s.condition6)
	e6:SetTarget(s.target6)
	e6:SetOperation(s.operation6)
  e6:SetCountLimit(1,id)
	c:RegisterEffect(e6)
end
function s.condition(e)
  return bcot.kanohi_con(e,{0x2b02})
end
function s.filter6(c,tp)
	return c:IsCode(10100013) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.condition6(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.filter6,1,nil,tp)
end
function s.target6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation6(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local g=eg:FilterSelect(tp,s.filter6,1,1,nil,tp)
	if g:GetCount()>0 then
    Duel.Equip(tp,e:GetHandler(),g:GetFirst())
	end
end
