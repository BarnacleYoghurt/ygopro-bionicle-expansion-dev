--Matoran Pilot Kongu
local s,id=GetID()
function s.initial_effect(c)
	--To GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
  local e1b=e1:Clone()
  e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e1b)
	--Destroy monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)	
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end
function s.filter1(c)
	return c:IsRace(RACE_WINGEDBEAST) and c:IsSetCard(0xb06) and c:IsAbleToGrave()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
  if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
		e1:SetDescription(3205)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
  end
end
function s.limit1_1(e,c)
	return e:GetOwner()==c
end
function s.filter2a(c,tp)
  return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToRemoveAsCost() and Duel.IsExistingTarget(s.filter2b,1-tp,LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function s.filter2b(c,atk)
	return c:IsFaceup() and c:IsDefenseBelow(atk)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_GRAVE,0,1,1,nil,tp)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  e:SetLabel(g:GetFirst():GetAttack())
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter2b(chkc,e:GetLabel()) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filter2b,tp,0,LOCATION_MZONE,1,1,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end