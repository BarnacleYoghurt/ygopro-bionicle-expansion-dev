--Ussal, Crab Rahi
function c10100130.initial_effect(c)	
	--Manually enable Pendulum for later tweaking
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_FIELD)
	e0a:SetCode(EFFECT_SPSUMMON_PROC_G)
	e0a:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0a:SetRange(LOCATION_PZONE)
	e0a:SetCountLimit(1,10000000)
	e0a:SetCondition(c10100130.condition0a)
	e0a:SetOperation(c10100130.operation0a)
	e0a:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e0a)
	local e0b=Effect.CreateEffect(c)
	e0b:SetDescription(1160)
	e0b:SetType(EFFECT_TYPE_ACTIVATE)
	e0b:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0b)
	--Pendulum from Grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100130,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c10100130.cost1)
	e1:SetOperation(c10100130.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100130,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c10100130.target2)
	e2:SetOperation(c10100130.operation2)
	e2:SetCountLimit(1,10100130)
	c:RegisterEffect(e2)	
	--To Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100130,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c10100130.target3)
	e3:SetOperation(c10100130.operation3)
	e3:SetCountLimit(1,10100130)
	c:RegisterEffect(e3)
end
function c10100130.filter0a(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not (c:IsLocation(LOCATION_GRAVE) and not (c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x15a)))
		and not c:IsForbidden()
end
function c10100130.condition0a(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if c:GetSequence()~=6 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c10100130.filter0a,1,nil,e,tp,lscale,rscale)
	else
		if e:GetHandler():GetFlagEffect(10100130)~=0 then
			return Duel.IsExistingMatchingCard(c10100130.filter0a,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,lscale,rscale)
		else
			return Duel.IsExistingMatchingCard(c10100130.filter0a,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
		end
	end
end
function c10100130.operation0a(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,c10100130.filter0a,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=nil
		if e:GetHandler():GetFlagEffect(10100130)~=0 then
			g=Duel.SelectMatchingCard(tp,c10100130.filter0a,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,ft,nil,e,tp,lscale,rscale)
			local tc=g:GetFirst()
			while tc do
				if tc:IsLocation(LOCATION_GRAVE) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetCategory(CATEGORY_DESTROY)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetRange(LOCATION_MZONE)
					e1:SetTarget(c10100130.target0a_1)
					e1:SetOperation(c10100130.operation0a_1)
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0xff0000)
					e1:SetCountLimit(1)
					tc:RegisterEffect(e1)
				end
				tc=g:GetNext()
			end
		else
			g=Duel.SelectMatchingCard(tp,c10100130.filter0a,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
		end
		sg:Merge(g)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
function c10100130.target0a_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10100130.operation0a_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c10100130.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	if chk==0 then return tc and tc:GetLeftScale()>1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(-1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1ff0000)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	tc:RegisterEffect(e2)
end
function c10100130.operation1(e,tp,eg,ep,ev,re,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():RegisterFlagEffect(10100130,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ff0000,0,1)
	end
end
function c10100130.filter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(4) and c~=e:GetHandler() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100130.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100130.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c10100130.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c10100130.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100130.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100130.filter3(c,e,tp)
	return c:IsSetCard(0x15a) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100130.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100130.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c10100130.filter3,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c10100130.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100130.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
