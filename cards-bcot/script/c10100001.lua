if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Toa Mata Tahu
local s,id=GetID()
function s.initial_effect(c)
  --Tribute from hand
  local e1=bcot.toa_mata_tribute(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
  --ATK to 0 + bonus damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLED)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
s.listed_series={0x1b02}
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
    local fid=c:GetFieldID()
    --Slight flaw: This doesn't reset when leaving the field by ways other than battle destruction, because in that case the reset would happen before the effect triggers
    --However, RESET_TOFIELD means it can only ever be a problem if you manage to destroy a card outside the field by battle 
    tc:RegisterFlagEffect(id,RESET_EVENT+RESET_TURN_SET+RESET_OVERLAY+RESET_MSCHANGE+RESET_TOFIELD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,2))
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLE_DESTROYED)
    e2:SetOperation(s.operation2_2)
    e2:SetLabel(fid)
    e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
	end
end
function s.operation2_2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if eg:IsContains(tc) then
    if tc:GetFlagEffectLabel(id)==e:GetLabel() then
      Duel.Hint(HINT_CARD,0,id)
      Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
      tc:ResetFlagEffect(id)
      e:Reset()
    else
      e:Reset()
    end
  end
end
