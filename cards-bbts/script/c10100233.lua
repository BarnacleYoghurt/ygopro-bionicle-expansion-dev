if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Bahrag Cahdok, Queen of the Bohrok
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xb08),1,1,Synchro.NonTuner(Card.IsSetCard,0xb08),1,99)
	c:EnableReviveLimit()
	--Flip
	local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_POSITION)
  e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.condition1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
  local e1b=e1:Clone()
  e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e1b)
	--Special Summon
	local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Effect Protect
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_FIELD)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetTargetRange(LOCATION_MZONE,0)
	e3a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3a:SetCondition(s.condition3)
	e3a:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xb0a))
	e3a:SetValue(s.value3a)
	c:RegisterEffect(e3a)
	local e3b=e3a:Clone()
	e3b:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3b:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3b:SetValue(aux.tgoval)
	c:RegisterEffect(e3b)
	--Pendulum
	local e4=bbts.bahrag_pendset(c)
	c:RegisterEffect(e4)
end
function s.filter1(c)
	return c:IsSetCard(0xb08) and c:IsFaceup() and c:IsCanTurnSet()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter1,1,nil)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g=eg
  if g:GetCount()>1 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    g=g:FilterSelect(tp,s.filter1,1,1,nil)
  end
  if g:GetCount()>0 then
    local tc=g:GetFirst()
    if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0 then 
      local rc=1
      if Duel.GetTurnPlayer()==tp then
        rc=2
      end
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
      e1:SetCondition(s.condition1_1)
      e1:SetValue(1)
      e1:SetReset(RESET_EVENT+(RESETS_STANDARD&~RESET_TURN_SET)+RESET_PHASE+PHASE_STANDBY,rc)
      tc:RegisterEffect(e1)
      local e2=Effect.CreateEffect(e:GetHandler())
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
      e2:SetCondition(s.condition1_2)
      e2:SetValue(1)
      e2:SetReset(RESET_EVENT+(RESETS_STANDARD&~RESET_TURN_SET)+RESET_PHASE+PHASE_STANDBY,rc)
      tc:RegisterEffect(e2)
      --Check if face-down at start of Damage Step
      local e3=Effect.CreateEffect(e:GetHandler())
      e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
      e3:SetCode(EVENT_BATTLE_START)
      e3:SetCondition(s.condition1_3)
      e3:SetOperation(s.operation1_3)
      e3:SetReset(RESET_EVENT+(RESETS_STANDARD&~RESET_TURN_SET)+RESET_PHASE+PHASE_STANDBY,rc)
      tc:RegisterEffect(e3)
    end
  end
end
function s.condition1_1(e)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.condition1_2(e)
	return e:GetHandler():IsFacedown()
end
function s.condition1_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFacedown() and c:IsLocation(LOCATION_MZONE)
end
function s.operation1_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)==0 then
		c:RegisterFlagEffect(id,RESET_PHASE+PHASE_DAMAGE,0,1)
	end
end
function s.filter2(c,e,tp)
	return c:IsSetCard(0xb08) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCondition(s.condition2_1)
		e1:SetOperation(s.operation2_1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.condition2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.operation2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function s.filter3(c)
	return c:IsFaceup() and c:IsCode(10100232)
end
function s.condition3(e)
	return Duel.IsExistingMatchingCard(s.filter3,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.value3a(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
