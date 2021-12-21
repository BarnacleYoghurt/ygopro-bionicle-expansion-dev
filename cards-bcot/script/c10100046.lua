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
	e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(aux.dxmcostgen(1,1,s.costproc2))
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function s.condition1(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.filter2WIND(c)
	return c:IsLevel(2) and c:IsSetCard(0xb01) and c:IsAbleToHand()
end
function s.filter2LIGHTDARK(c,e,tp)
	return c:GetLevel()==2 and c:IsSetCard(0xb01) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.costproc2(e,og)
	e:SetLabel(og:GetFirst():GetOriginalAttribute())
end
function s.target2WIND(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter2WIND,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.target2EARTH(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.target2LIGHTDARK(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter2LIGHTDARK,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return (e:GetHandler():GetOverlayGroup():IsExists(aux.NOT(Card.IsAttribute),1,nil,ATTRIBUTE_WIND) or s.target2WIND(e,tp,eg,ep,ev,re,r,rp,0))
      and (e:GetHandler():GetOverlayGroup():IsExists(aux.NOT(Card.IsAttribute),1,nil,ATTRIBUTE_EARTH) or s.target2EARTH(e,tp,eg,ep,ev,re,r,rp,0))
      and (e:GetHandler():GetOverlayGroup():IsExists(aux.NOT(Card.IsAttribute),1,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) or s.target2LIGHTDARK(e,tp,eg,ep,ev,re,r,rp,0))
  end
	local att=e:GetLabel()
  if att==ATTRIBUTE_WIND then s.target2WIND(e,tp,eg,ep,ev,re,r,rp,1) end
  if att==ATTRIBUTE_EARTH then s.target2EARTH(e,tp,eg,ep,ev,re,r,rp,1) end
  if att==ATTRIBUTE_LIGHT or att==ATTRIBUTE_DARK then s.target2LIGHTDARK(e,tp,eg,ep,ev,re,r,rp,1) end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local att=e:GetLabel()
  if att==ATTRIBUTE_WIND then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter2WIND,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
	end
  if att==ATTRIBUTE_WATER then
		local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(function (e,c) return c:IsFaceup() and c:IsSetCard(0xb01) end)
    e1:SetValue(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
	end
	if att==ATTRIBUTE_FIRE then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(600)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
	if att==ATTRIBUTE_EARTH then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Draw(p,d,REASON_EFFECT)>0 then
      Duel.ShuffleHand(tp)
      Duel.BreakEffect()
      Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
    end
	end
	if att==ATTRIBUTE_LIGHT or att==ATTRIBUTE_DARK then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter2LIGHTDARK,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
	end
end