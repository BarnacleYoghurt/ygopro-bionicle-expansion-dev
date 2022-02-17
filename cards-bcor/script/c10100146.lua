--Matoran Assistant Hahli
local s,id=GetID()
function s.initial_effect(c)
  --Protect
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.target1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Burn
	local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1,id+1000000)
	c:RegisterEffect(e3)
end
function s.target1(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0xb01)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsMainPhase()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(400)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end
function s.filter3(c,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0xb01) and not c:IsCode(id) and c:IsControler(tp)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)		
	return eg:IsExists(s.filter3,1,nil,tp)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)		
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
    local fid=c:GetFieldID()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCondition(s.condition3_1)
    e1:SetOperation(s.operation3_1)
    e1:SetLabel(fid)
    e1:SetLabelObject(c)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
	end
end
function s.condition3_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.operation3_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
