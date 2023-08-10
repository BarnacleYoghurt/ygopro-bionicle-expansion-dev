if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Toa Mata Combination - Magma
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1b02),6,2)
	c:EnableReviveLimit()
	--Dump'n'nerf
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id) 
	c:RegisterEffect(e1)
  --Tag out
  local e2=bcot.toa_mata_combination_tagout(c,ATTRIBUTE_FIRE,ATTRIBUTE_EARTH)
	e2:SetDescription(aux.Stringid(id,1))
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
s.listed_series={0x1b02}
function s.filter1(c)
	return c:GetLevel()==1 and c:IsRace(RACE_ROCK) and (c:GetAttack()==0 and c:IsDefenseBelow(0)) and c:IsAbleToGrave()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and Duel.SendtoGrave(g1,REASON_EFFECT)>0 and g1:GetFirst():IsLocation(LOCATION_GRAVE)
    and Duel.IsExistingMatchingCard(Card.IsFaceup,1-tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,1-tp,LOCATION_MZONE,0,1,1,nil)
		if g2:GetCount()>0 then
      local tc=g2:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_SET_ATTACK_FINAL)
      e1:SetValue(tc:GetAttack()/2)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD)
      tc:RegisterEffect(e1)
      local e2=Effect.CreateEffect(e:GetHandler())
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
      e2:SetValue(tc:GetDefense()/2)
      e2:SetReset(RESET_EVENT+RESETS_STANDARD)
      tc:RegisterEffect(e2)
		end
	end
end