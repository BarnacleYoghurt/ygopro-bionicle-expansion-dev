if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Toa Mata Combination - Storm
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1b02),6,2)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCondition(s.condition1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id) 
	c:RegisterEffect(e1)
	--Tag out
  local e2=bcot.toa_mata_combination_tagout(c,ATTRIBUTE_WIND,ATTRIBUTE_WATER)
	e2:SetDescription(aux.Stringid(id,1))
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
s.listed_series={0x1b02}
function s.filter1(c,e,tp)
	return c:IsSetCard(0x1b02) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() or Duel.IsBattlePhase()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
    local c=e:GetHandler()
    local tc=g:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetValue(0)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    tc:RegisterEffect(e1)
    local e2a=Effect.CreateEffect(c)
    e2a:SetDescription(3310)
    e2a:SetType(EFFECT_TYPE_SINGLE)
		e2a:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e2a:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e2a:SetValue(1)
    e2a:SetReset(RESET_EVENT+RESETS_STANDARD)
    tc:RegisterEffect(e2a)
    local e2b=e2a:Clone()
    e2b:SetDescription(3311)
    e2b:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    tc:RegisterEffect(e2b)
    local e2c=e2a:Clone()
    e2c:SetDescription(3312)
    e2c:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    tc:RegisterEffect(e2c)
    local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCondition(s.condition1_3)
		e3:SetOperation(s.operation1_3)
		e3:SetLabel(Duel.GetTurnCount()+1)
		e3:SetLabelObject(tc)
		e3:SetCountLimit(1)
		e3:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3,tp)
		tc:CreateEffectRelation(e3)
    
    Duel.SpecialSummonComplete()
	end
end
function s.condition1_3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function s.operation1_3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
