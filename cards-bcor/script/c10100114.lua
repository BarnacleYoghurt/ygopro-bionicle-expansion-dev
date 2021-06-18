--Dikapi, Ostrich Rahi
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xb06),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--Change Level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--Extra Synchro
  local smat=Group.FromCards(c) --To force using this card in alternate procedure
  smat:KeepAlive()
	local synproc=Effect.CreateEffect(c) --Alternate Synchro Procedure
	synproc:SetType(EFFECT_TYPE_FIELD)
	synproc:SetDescription(aux.Stringid(id, 1))
	synproc:SetCode(EFFECT_SPSUMMON_PROC)
	synproc:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	synproc:SetRange(LOCATION_EXTRA)
	synproc:SetCondition(s.synproc_condition)
	synproc:SetTarget(s.synproc_target)
	synproc:SetOperation(Synchro.Operation)
  synproc:SetLabelObject(smat)
	synproc:SetValue(SUMMON_TYPE_SYNCHRO)
	local e2=Effect.CreateEffect(c) --Grant synproc to all Synchros in ED
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_EXTRA,0)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetLabelObject(synproc)
	c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c) --Allow no other materials when using ED
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(Duel.AnnounceNumber(tp,1,2,3,4))
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,e:GetLabel()*300)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if e:GetHandler():IsRelateToEffect(e) and lv>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1*lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetHandler():RegisterEffect(e1) then
			Duel.BreakEffect()
			Duel.Damage(tp,lv*300,REASON_EFFECT)
		end
	end
end

function s.synproc_getBaseSynproc(sc) --Get the Synchro Summon Procedure of sc (false if none registered)
	local ssprocs = {sc:GetCardEffect(EFFECT_SPSUMMON_PROC)}
	for _,ssproc in ipairs(ssprocs) do
		if ssproc:GetValue()==SUMMON_TYPE_SYNCHRO then
			return ssproc
		end
	end
	return false
end
function s.synproc_filter(c)
  return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xb06)
end
function s.synproc_condition(e,c,smat,mg,min,max)
	local fun = s.synproc_getBaseSynproc(e:GetHandler()):GetCondition()
  if not smat then smat=Group.CreateGroup() end
  if not mg then mg=Group.CreateGroup() end
  smat:Merge(e:GetLabelObject())
  mg:Merge(e:GetLabelObject())
  mg:Merge(Duel.GetMatchingGroup(s.synproc_filter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil))
	return fun(e,c,smat,mg,min,max)
end
function s.synproc_target(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
	local fun = s.synproc_getBaseSynproc(e:GetHandler()):GetTarget()
  if not smat then smat=Group.CreateGroup() end
  if not mg then mg=Group.CreateGroup() end
  smat:Merge(e:GetLabelObject())
  mg:Merge(e:GetLabelObject())
  mg:Merge(Duel.GetMatchingGroup(s.synproc_filter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil))
	return fun(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
end

function s.condition2(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function s.target2(e,c)
	return not (c:IsFaceup() and c:IsType(TYPE_PENDULUM)) and s.synproc_getBaseSynproc(c) --Only cards that can be synchro summoned
end

function s.operation3(e,tg,ntg,sg,lv,sc,tp)
	return (not sg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA)) or sg:GetCount()==2,false
end
