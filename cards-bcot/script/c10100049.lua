if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Great Kanohi Rua
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
  e2:SetCondition(s.condition)
  e2:SetValue(s.value2)
	c:RegisterEffect(e2)
	--Hand Reveal
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e3)
	--Equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(s.condition4)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation4)
  e4:SetCountLimit(1,id)
	c:RegisterEffect(e4)
end
function s.condition(e)
  return bcot.kanohi_con(e,{0x2b02})
end
function s.value2(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function s.filter4(c,tp)
	return c:IsCode(10100014) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.condition4(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.filter4,1,nil,tp)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local g=eg:FilterSelect(tp,s.filter4,1,1,nil,tp)
	if g:GetCount()>0 then
    Duel.Equip(tp,e:GetHandler(),g:GetFirst())
	end
end