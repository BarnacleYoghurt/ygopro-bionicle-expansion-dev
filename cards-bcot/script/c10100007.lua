if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Great Kanohi Hau
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.condition2)
	c:RegisterEffect(e2)
  --Destroy if replaced
  local e3=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e3)
  --Indestructible by battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--No damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Search
	local e6=Effect.CreateEffect(c)
  e6:SetDescription(id,0)
  e6:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
  e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCost(s.cost6)
  e6:SetTarget(s.target6)
  e6:SetOperation(s.operation6)
  e6:SetCountLimit(1,id)
	c:RegisterEffect(e6)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsLevelAbove(6)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc)
	end
end
function s.condition2(e,c)
	return c:IsLevelAbove(6)
end
function s.filter6a(c)
  return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.filter6b(c)
  return c:IsCode(10100001) and c:IsAbleToHand()
end
function s.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter6a,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,s.filter6a,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.target6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter6b,tp,LOCATION_DECK,0,1,nil) end
  local tc=Duel.GetFirstMatchingCard(s.filter6b,tp,LOCATION_DECK,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,tc,1,0,0)
end
function s.operation6(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstMatchingCard(s.filter6b,tp,LOCATION_DECK,0,nil)
  if tc then
    Duel.SendtoHand(tc,tp,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tc)
  end
end