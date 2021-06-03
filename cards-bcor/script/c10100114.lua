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
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetValue(1)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end
function s.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb06) and c:IsLevelAbove(1) and c:IsAbleToRemoveAsCost()
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
function s.filter2a(c,syncard,tuner,f)
	return c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function s.filter2b(c,syncard,tuner,f,g,lv,minc,maxc)
	if c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c)) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xb06) then
		lv=lv-c:GetLevel()
		if lv<0 then return false end
		if lv==0 then return minc==1 end
		return g and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc-1,maxc-1,syncard)
	else return false end
end
function s.condition2(e)
  Debug.Message("cond2")
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function s.target2(e,syncard,f,minc,maxc)
  Debug.Message("tg2")
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g1=Duel.GetMatchingGroup(s.filter2a,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	return g1:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
		or Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_EXTRA,0,1,nil,syncard,c,f,nil,lv,minc,maxc)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g1=Duel.GetMatchingGroup(s.filter2a,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local g2=Duel.GetMatchingGroup(s.filter2b,tp,LOCATION_EXTRA,0,nil,syncard,c,f,nil,lv,minc,maxc)
	if not g1:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
		or (g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=g2:Select(tp,1,1,nil)
		Duel.SetSynchroMaterial(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=g1:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
		Duel.SetSynchroMaterial(sg)
	end
end
