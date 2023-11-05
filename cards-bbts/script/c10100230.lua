if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Bohrok Va Kaita Ja
function s.initial_effect(c)
	--Fusion Material
	Fusion.AddProcMix(c,true,true,10100217,10100220,10100221)
	c:EnableReviveLimit()
	--Synchro Limit
	local e1=bbts.bohrokvakaita_synchrolimit(c)
	c:RegisterEffect(e1)
	--Switch
	local e2=bbts.bohrokvakaita_switch(c)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsPreviousLocation(LOCATION_ONFIELD) then
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetTarget(s.target3_1)
    e1:SetOperation(s.operation3_1)
    e1:SetCountLimit(1,id)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
  end
end
function s.filter3_1(c)
	return (c:IsSetCard(0xb08) or c:IsSetCard(0xb09)) and c:IsAbleToHand()
end
function s.target3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter3_1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation3_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter3_1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
