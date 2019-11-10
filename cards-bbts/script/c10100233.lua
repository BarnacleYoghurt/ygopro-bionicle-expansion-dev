if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bahrag Cahdok, Queen of the Bohrok
function c10100233.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x15c),aux.NonTuner(Card.IsSetCard,0x15c),1)
	c:EnableReviveLimit()
	--Flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10100233)
	e1:SetCondition(c10100233.condition1)
	e1:SetOperation(c10100233.operation1)
	c:RegisterEffect(e1)
  local e1b=e1:Clone()
  e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e1b)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10100233.condition2)
	e2:SetTarget(c10100233.target2)
	e2:SetOperation(c10100233.operation2)
  e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Effect Protect
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_FIELD)
	e3a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetTargetRange(LOCATION_MZONE,0)
	e3a:SetCondition(c10100233.condition3)
	e3a:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15e))
	e3a:SetValue(c10100233.value3a)
	c:RegisterEffect(e3a)
	local e3b=e3a:Clone()
	e3b:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3b:SetValue(aux.tgoval)
	e3b:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e3b)
	--Pendulum
	local e4=bbts.bahrag_pendset(c)
	c:RegisterEffect(e4)
end
function c10100233.filter1(c)
	return c:IsSetCard(0x15c) and c:IsFaceup() and c:IsCanTurnSet()
end
function c10100233.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10100233.filter1,1,nil)
end
function c10100233.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterSelect(tp,c10100233.filter1,1,1,nil)
  local tc=g:GetFirst()
	if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) then 
    local rc=1
    if Duel.GetTurnPlayer()==tp then
      rc=2
    end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetCondition(c10100233.condition1_1)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_STANDBY,rc)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetCondition(c10100233.condition1_2)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_STANDBY,rc)
		tc:RegisterEffect(e2)
		--Check if face-down at start of Damage Step
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLE_START)
		e3:SetCondition(c10100233.condition1_3)
		e3:SetOperation(c10100233.operation1_3)
		e3:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_STANDBY,rc)
		tc:RegisterEffect(e3)
	end
end
function c10100233.condition1_1(e)
	return e:GetHandler():GetFlagEffect(10100233)~=0
end
function c10100233.condition1_2(e)
	return e:GetHandler():IsFacedown()
end
function c10100233.condition1_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFacedown() and c:IsLocation(LOCATION_MZONE)
end
function c10100233.operation1_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(10100233)==0 then
		c:RegisterFlagEffect(10100233,RESET_PHASE+PHASE_DAMAGE,0,1)
	end
end
function c10100233.filter2(c,e,tp)
	return c:IsSetCard(0x15c) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100233.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c10100233.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100233.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.GetMatchingGroup(c10100233.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100233.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c10100233.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(10100233,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c10100233.condition2_1)
		e1:SetOperation(c10100233.operation2_1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10100233.condition2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(10100233)==e:GetLabel()
end
function c10100233.operation2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c10100233.filter3(c)
	return c:IsFaceup() and c:IsCode(10100232)
end
function c10100233.condition3(e)
	return Duel.IsExistingMatchingCard(c10100233.filter3,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c10100233.value3a(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
