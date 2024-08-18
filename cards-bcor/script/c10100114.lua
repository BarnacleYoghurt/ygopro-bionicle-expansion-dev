--Dikapi, Ostrich Rahi
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--OPT Special Summon
	c:SetSPSummonOnce(id)
	--Extra Synchro
	local smat=Group.FromCards(c) --To force using this card in alternate procedure
	smat:KeepAlive()
	local synproc=Effect.CreateEffect(c) --Alternate Synchro Procedure
	synproc:SetType(EFFECT_TYPE_FIELD)
	synproc:SetDescription(aux.Stringid(id, 0))
	synproc:SetCode(EFFECT_SPSUMMON_PROC)
	synproc:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	synproc:SetRange(LOCATION_EXTRA)
	synproc:SetCondition(s.synproc_condition)
	synproc:SetTarget(s.synproc_target)
	synproc:SetOperation(Synchro.Operation)
	synproc:SetLabelObject(smat)
	synproc:SetValue(SUMMON_TYPE_SYNCHRO)
	local e1=Effect.CreateEffect(c) --Grant synproc to all Rahi Synchros in ED
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_EXTRA,0)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetLabelObject(synproc)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c) --Allow no other materials and make Level flexible when using ED
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
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
  return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_BEAST|RACE_WINGEDBEAST)
end
function s.synproc_condition(e,c,smat,mg,min,max)
	local fun=s.synproc_getBaseSynproc(e:GetHandler()):GetCondition()
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
function s.condition1(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.target1(e,c)
	return not (c:IsFaceup() and c:IsType(TYPE_PENDULUM)) and c:IsSetCard(0xb06)
		and s.synproc_getBaseSynproc(c) --Only cards that can be synchro summoned
end
function s.operation2(e,tg,ntg,sg,lv,sc,tp)
	if not sg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then return true,false end
	if sg:GetCount()~=2 then return false,false end
	local c=e:GetHandler()
	local ol=(sg-c):GetFirst():GetSynchroLevel(sc)
	return c:GetSynchroLevel(sc)+ol==lv or (lv>=1+ol and lv<=5+ol),true
end
function s.filter3(c)
	return c:IsFaceup() and c:IsMonster() and c:IsAbleToDeck()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return s.filter3(chkc) and chck:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then
		return Duel.IsExistingTarget(s.filter3,tp,LOCATION_REMOVED,0,1,nil)
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
		if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end