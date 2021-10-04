--Le-Koro, Village of Air
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --Attack restriction
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.value1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2a=Effect.CreateEffect(c)
	e2a:SetDescription(aux.Stringid(id,0))
	e2a:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2a:SetCode(EVENT_SUMMON_SUCCESS)
	e2a:SetRange(LOCATION_FZONE)
	e2a:SetTarget(s.target2)
	e2a:SetOperation(s.operation2)
	e2a:SetCountLimit(1,id)
	c:RegisterEffect(e2a)
  local e2b=e2a:Clone()
  e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2b)
end
s.listed_attributes = {ATTRIBUTE_WIND}
function s.filter1(c,atk)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:GetAttack()>atk
end
function s.value1(e,c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and Duel.IsExistingMatchingCard(s.filter1,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function s.filter2(c,tc)
  return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WARRIOR) and tc:HasLevel() and c:IsLevelBelow(tc:GetLevel())
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local tc=eg:Filter(Card.IsSummonPlayer,nil,tp):GetFirst()
	if chk==0 then return tc and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,tc) end
  tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=eg:Filter(Card.IsSummonPlayer,nil,tp):GetFirst()
  if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
		end
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e5:SetReset(RESET_PHASE+PHASE_END)
    e5:SetTargetRange(1,0)
    e5:SetTarget(s.target2_5)
    Duel.RegisterEffect(e5,tp)
    aux.RegisterClientHint(c,nil,tp,1,0,aux.Stringid(id,1),nil)
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,tc)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
function s.target2_5(e,c)
  return not c:IsAttribute(ATTRIBUTE_WIND)
end