--Dimnished Matoran Kaita
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb01),2,3)
	c:EnableReviveLimit()
	--Indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.condition1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Detach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
s.listed_series={0xb01}
function s.condition1(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.filter2WIND(c)
	return c:IsLevel(2) and c:IsSetCard(0xb01) and c:IsAbleToHand()
end
function s.filter2LIGHTDARK(c,e,tp)
	return c:GetLevel()==2 and c:IsSetCard(0xb01) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local c=e:GetHandler()
    local g=c:GetOverlayGroup()
    local att=ATTRIBUTE_WATER | ATTRIBUTE_FIRE
    if Duel.IsExistingMatchingCard(s.filter2WIND,tp,LOCATION_DECK,0,1,nil) then att=att | ATTRIBUTE_WIND end
    if Duel.IsPlayerCanDraw(tp,1) then att=att | ATTRIBUTE_EARTH end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter2LIGHTDARK,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then 
      att=att | ATTRIBUTE_LIGHT | ATTRIBUTE_DARK 
    end
    return att>0 and g:IsExists(Card.IsAttribute,1,nil,att) 
  end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  --Detach up to 3 materials with different attributes
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=c:GetOverlayGroup()
	local avAtt=ATTRIBUTE_WATER
  if c:IsFaceup() then avAtt=avAtt | ATTRIBUTE_FIRE end
  if Duel.IsExistingMatchingCard(s.filter2WIND,tp,LOCATION_DECK,0,1,nil) then avAtt=avAtt | ATTRIBUTE_WIND end
  if Duel.IsPlayerCanDraw(tp,1) then avAtt=avAtt | ATTRIBUTE_EARTH end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter2LIGHTDARK,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then 
    avAtt=avAtt | ATTRIBUTE_LIGHT | ATTRIBUTE_DARK
  end
	if avAtt==0 then return end --technically redundant, but eh
	local sg=aux.SelectUnselectGroup(g:Filter(Card.IsAttribute,nil,avAtt),e,tp,1,3,
    function(sg,e,tp,mg) return sg:GetClassCount(Card.GetAttribute)==sg:GetCount() end,1,tp,HINTMSG_REMOVEXYZ)
	local att=0
	for tc in aux.Next(sg) do
		att=att | tc:GetAttribute()
	end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
  
  --Apply the appropriate effect(s)
	if att & ATTRIBUTE_WIND ~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter2WIND,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
      Duel.BreakEffect()
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
	end
  if att & ATTRIBUTE_WATER ~=0 then
    Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3001)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
	end
	if att & ATTRIBUTE_FIRE ~= 0 then
    Duel.BreakEffect()
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(1200)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e2)
	end
	if att & ATTRIBUTE_EARTH ~= 0 then
    Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if att & (ATTRIBUTE_LIGHT | ATTRIBUTE_DARK) ~= 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2LIGHTDARK),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
      Duel.BreakEffect()
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
	end
end