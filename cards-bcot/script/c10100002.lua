if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Toa Mata Gali
local s,id=GetID()
function s.initial_effect(c)
  --Tribute from hand
  local e1=bcot.toa_mata_tribute(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
  --Negate
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
end
s.listed_series={0x1b02}
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsCode(id) and rp==1-Duel.GetTurnPlayer()
    and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) --Can be activated up to damage calc because ATK Change, like AD Thunder Lv10
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsNegatableMonster() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsNegatableMonster,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,Card.IsNegatableMonster,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
  if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
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
    if not tc:IsImmuneToEffect(e1) and not tc:IsImmuneToEffect(e2) then
      local e3=Effect.CreateEffect(c)
      e3:SetType(EFFECT_TYPE_SINGLE)
      e3:SetCode(EFFECT_UPDATE_ATTACK)
      e3:SetValue(400)
      e3:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
      c:RegisterEffect(e3)
    end
	end
end