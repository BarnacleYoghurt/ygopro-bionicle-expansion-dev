if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Toa Mata Onua
local s,id=GetID()
function s.initial_effect(c)
  --Tribute from hand
  local e1=bcot.toa_mata_tribute(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
  --Recycle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP) --TODO: Would it be correct that only battle damage can trigger in damage step?
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
  --Kanohi swap
  local e3=bcot.toa_mata_swapkanohi(c)
	e3:SetDescription(aux.Stringid(id,2))
	c:RegisterEffect(e3)
end
function s.filter2(c,dmg)
  return c:IsType(TYPE_MONSTER) and c:IsAttackBelow(dmg) and c:IsAbleToHand()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return ep==1-tp
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return s.filter2(chkc,ev) and chkc:IsLocation(LOCATION_GRAVE) end
  if chk==0 then
    return Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil,ev)
  end
  local tc=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,ev)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SendtoHand(tc,tp,REASON_EFFECT)
    
    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.value2_1)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
  end
end
function s.value2_1(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end