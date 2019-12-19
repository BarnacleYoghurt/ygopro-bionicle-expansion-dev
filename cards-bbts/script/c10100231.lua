if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Va Kaita Za
function c10100231.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCode3(c,10100216,10100218,10100219,true,true)
	c:EnableReviveLimit()
	--Synchro Limit
	local e1=bbts.bohrokvakaita_synchrolimit(c)
	c:RegisterEffect(e1)
	--Switch
	local e2=bbts.bohrokvakaita_switch(c)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c10100231.operation3)
	c:RegisterEffect(e3)
end
function c10100231.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsPreviousLocation(LOCATION_ONFIELD) then
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetDescription(aux.Stringid(10100231,1))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetTarget(c10100231.target3_1)
    e1:SetOperation(c10100231.operation3_1)
    e1:SetCountLimit(1,10100231)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
  end
end
function c10100231.filter3_1(c,e,tp)
	return c:IsSetCard(0x15c) and not c:IsCode(10100231) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100231.target3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100231.filter3_1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c10100231.filter3,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100231.operation3_1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c10100231.filter3_1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
