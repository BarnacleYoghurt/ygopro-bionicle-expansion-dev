--Makoki Stone
local s,id=GetID()
local COUNTER_KEY=0x10b1
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
  c:SetCounterLimit(COUNTER_KEY,6)
	--Activate
	local e0=Effect.CreateEffect(c)
  e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
  e0:SetTarget(s.target0)
  e0:SetOperation(s.operation0)
	c:RegisterEffect(e0)
	--Add counter
  local e1a=Effect.CreateEffect(c)
  e1a:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1a:SetRange(LOCATION_SZONE)
	e1a:SetCode(EVENT_CHAINING)
	e1a:SetOperation(aux.chainreg)
	c:RegisterEffect(e1a)
	local e1b=Effect.CreateEffect(c)
	e1b:SetCategory(CATEGORY_COUNTER)
	e1b:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1b:SetRange(LOCATION_SZONE) 
	e1b:SetCode(EVENT_CHAIN_SOLVING)
  e1b:SetCondition(s.condition1)
	e1b:SetOperation(s.operation1)
	c:RegisterEffect(e1b)
	--To hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
end
s.listed_series={0xb01,0xb03,0xb02}
s.counter_place_list={COUNTER_KEY}
function s.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil,tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.operation0(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil,tp,POS_FACEDOWN):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)>0 then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
		e:SetLabelObject(tc)
	end
end
function s.filter1(c)
	return c:IsSetCard(0xb01) or c:IsSetCard(0xb02) or c:IsSetCard(0xb03)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return re and s.filter1(re:GetHandler()) and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetFlagEffect(1)>0
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  e:GetHandler():AddCounter(COUNTER_KEY,1)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsStatus(STATUS_EFFECT_ENABLED) and c:IsAbleToGraveAsCost() and c:GetCounter(COUNTER_KEY)==6 end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject():GetLabelObject()
	if chk==0 then return tc and tc:GetFlagEffect(id)>0 and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	if tc and tc:GetFlagEffect(id)~=0 then
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
  end
end
