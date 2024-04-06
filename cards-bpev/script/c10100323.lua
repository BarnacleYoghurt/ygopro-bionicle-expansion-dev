if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Nuva Symbol of Soaring Vitality
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --Search EP or Lewa
  local e1=bpev.nuva_symbol_search(c,10100006,aux.Stringid(id,3))
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,{id,1})
	c:RegisterEffect(e2)
  --Leave field
  local e3=bpev.nuva_symbol_punish(c,s.operation3)
  e3:SetDescription(aux.Stringid(id,2))
  c:RegisterEffect(e3)
end
function s.filter2a(c,tp)
  return c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0x3b02) and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
end
function s.filter2b(c,e,tp)
  return c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.filter2a,1,nil,tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return s.filter2b(chkc,e,tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) end
  if chk==0 then return Duel.IsExistingTarget(s.filter2b,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local tc=Duel.SelectTarget(tp,s.filter2b,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
  if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
  end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(id,4))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
  e1:SetTargetRange(1,0)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
end