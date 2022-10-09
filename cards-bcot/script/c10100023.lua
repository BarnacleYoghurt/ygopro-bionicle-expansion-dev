--The Island of Mata Nui
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--ATK/DEF up
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD)
	e1a:SetRange(LOCATION_FZONE)
  e1a:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1a:SetCode(EFFECT_UPDATE_ATTACK)
	e1a:SetTarget(s.target1)
	e1a:SetValue(600)
	c:RegisterEffect(e1a)
  local e1b=e1a:Clone()
  e1b:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e1b)
	--Reveal & Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
	--Activate from GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.condition3)
  e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,{id,1})
	c:RegisterEffect(e3)
end
s.listed_names={10100024}
s.listed_series={0x1b02,0xb05}
function s.target1(e,c)
  return c:IsSetCard(0x1b02) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function s.filter2a(c,tp)
  return c:IsType(TYPE_MONSTER) and not c:IsPublic() and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_DECK,0,1,nil,c)
end
function s.filter2b(c,rc)
  if not c:IsAbleToHand() then return false end
  if (c:IsCode(10100024) and rc:IsSetCard(0x1b02)) then return true end
  if not (c:IsType(TYPE_FIELD) and c:IsSetCard(0xb05) and c.listed_attributes) then return false end
  
  for _,attr in ipairs(c.listed_attributes) do
    if rc:IsAttribute(attr) then return true end
  end
  return false
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local rg=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_HAND,0,1,1,nil,tp)
  if rg:GetCount()>0 then
    Duel.ConfirmCards(1-tp,rg)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local ag=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_DECK,0,1,1,nil,rg:GetFirst())
    if ag:GetCount()>0 then
      Duel.SendtoHand(ag,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,ag)
    end
  end
end
function s.filter3(c,tp)
  return c:IsPreviousLocation(LOCATION_FZONE) and c:IsPreviousControler(tp) and not c:IsCode(id)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter3,1,nil,tp)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():GetActivateEffect():IsActivatable(tp,true,true) end
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:GetActivateEffect():IsActivatable(tp,true,true) then
    if Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp) then
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(3300)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
      e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
      e1:SetValue(LOCATION_REMOVED)
      e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
      c:RegisterEffect(e1)
    end
  end
end