if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Noble Kanohi Matatu
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Change Position
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(bcot.noblekanohi_con)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
	--Recycle
  local e4=bcot.kanohi_revive(c,10100021)
  e4:SetDescription(aux.Stringid(id,1))
  e4:SetCountLimit(1,id)
  c:RegisterEffect(e4)
end
s.listed_names={10100021}
s.listed_series={0xb04,0xb03,0xb02,0xb07}
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipTarget():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
  local g=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
  end
end
    