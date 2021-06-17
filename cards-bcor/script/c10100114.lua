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
	local synproc=Effect.CreateEffect(c) --Alternate Synchro Procedure
	synproc:SetType(EFFECT_TYPE_FIELD)
	synproc:SetDescription(aux.Stringid(id, 1))
	synproc:SetCode(EFFECT_SPSUMMON_PROC)
	synproc:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	synproc:SetRange(LOCATION_EXTRA)
	synproc:SetCondition(s.synproc_condition)
	synproc:SetTarget(s.synproc_target)
	synproc:SetOperation(Synchro.Operation)
	synproc:SetValue(SUMMON_TYPE_SYNCHRO)
	local e2a=Effect.CreateEffect(c) --Grant synproc to all Synchros in ED
	e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetTargetRange(LOCATION_EXTRA,0)
	e2a:SetCondition(s.condition2)
	e2a:SetTarget(s.target2)
	e2a:SetLabelObject(synproc)
	c:RegisterEffect(e2a)
	local e2b=Effect.CreateEffect(c) --Hand Synchro (works with ED Pendulums thanks to synproc)
	e2b:SetType(EFFECT_TYPE_SINGLE)
	e2b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2b:SetCode(EFFECT_HAND_SYNCHRO)
	e2b:SetCondition(s.condition2)
	e2b:SetValue(s.value2)
	e2b:SetLabel(id)
	c:RegisterEffect(e2b)
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
	local sc=e:GetHandler()
	local ssprocs = {sc:GetCardEffect(EFFECT_SPSUMMON_PROC)}
	for _,ssproc in ipairs(ssproc) do
		if ssproc:GetDescription()==1172 then
			return ssproc
		end
	end
	return false
end
function s.synproc_runWithExtraHand(fun,...) --Run function with LOCATION_HAND "constant" altered to also include LOCATION_EXTRA
	local origval = LOCATION_HAND
	LOCATION_HAND = LOCATION_HAND + LOCATION_EXTRA --I deserve to be trampled by a herd of Kikanalo for this
	local res = fun(...)
	LOCATION_HAND = origval
	return res
end
function s.synproc_condition(e,c,smat,mg,min,max)
	local fun = s.synproc_getBaseSynproc(e:GetHandler()):GetCondition()
	return s.synproc_runWithExtraHand(fun,e,c,smat,mg,min,max)
end
function s.synproc_target(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
	local fun = s.synproc_getBaseSynproc(e:GetHandler()):GetTarget()
	return s.synproc_runWithExtraHand(fun,e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
end

function s.condition2(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function s.target2(e,c)
	return c:IsFacedown() and s.synproc_getBaseSynproc(c) --Only cards that can be synchro summoned
end
function s.value2(e,c,sc)
	if c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xb06) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		e1:SetLabel(id)
		e1:SetTarget(s.target2_1)
		c:RegisterEffect(e1)
		return true
	else return false end
end
function s.chk(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()~=id then return false end
	end
	return true
end
function s.chk2(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()==id then return true end
	end
	return false
end
function s.target2_1(e,c,sg,tg,ntg,tsg,ntsg)
	if c then
		local res=true
		if sg:IsExists(s.chk,1,c) or (not tg:IsExists(s.chk2,1,c) and not ntg:IsExists(s.chk2,1,c)
			and not sg:IsExists(s.chk2,1,c)) then return false end
		local trg=tg:Filter(s.chk,nil)
		local ntrg=ntg:Filter(s.chk,nil)
		return res,trg,ntrg
	else
		return true
	end
end
