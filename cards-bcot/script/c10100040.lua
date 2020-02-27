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
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  c:RegisterEffect(e3)
end
function s.condition2(e)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1
end
function s.filter3(c)
  return c:IsCode(10100017) and c:IsAbleToDeck()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_GRAVE,0,1,nil) and c:IsAbleToHand() end
  local g=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_GRAVE,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
  if Duel.SendtoDeck(g,tp,2,REASON_EFFECT)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then
    Duel.SendtoHand(c,tp,REASON_EFFECT)
  end
end