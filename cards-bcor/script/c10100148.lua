--Matoran Champion Huki
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetRange(LOCATION_HAND)
  e1:SetCondition(s.condition1)
	e1:SetValue(s.value1)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function s.condition1(e)
  return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0
end
function s.value1(e,c)
	local tp=c:GetControler()
	local zone=0x1f
	local lg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	for tc in aux.Next(lg) do
		zone=zone&(~tc:GetColumnZone(LOCATION_MZONE,0,0,tp))
	end
	return 0,zone
end
function s.filter2a(c,tp)
  local cg=c:GetColumnGroup()
  return c:IsFaceup() and cg:IsExists(s.filter2b,1,nil,tp)
end
function s.filter2b(c,tp)
  return c:IsFaceup() and c:IsSetCard(0xb01) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler() and chkc:IsLocation(LOCATION_MZONE) and s.filter2a(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter2a,1-tp,LOCATION_MZONE,0,1,nil,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter2a,1-tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and s.filter2a(tc,tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(tc:GetAttack())
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(3207)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e2)
	end
end
