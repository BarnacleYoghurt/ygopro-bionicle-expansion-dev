--Matoran Translator Matoro
function c10100149.initial_effect(c)
	--Flag
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetOperation(c10100149.operation0)
	c:RegisterEffect(e0)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100149,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10100149.condition1)
	e1:SetCost(c10100149.cost1)
	e1:SetTarget(c10100149.target1)
	e1:SetOperation(c10100149.operation1)
	e1:SetCountLimit(1,10100149)
	c:RegisterEffect(e1)
end
function c10100149.operation0(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10100149,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100149.filter1(c,e,tp)
	return c:IsSetCard(0x157) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(10100149)
end
function c10100149.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(10100149)>0
end
function c10100149.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10100149.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100149.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c10100149.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_GRAVE)
end
function c10100149.operation1(e,tp,eg,ep,ev,re,r,rp)	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100149.filter1,tp,LOCATION_GRAVE,0,1,2,nil,e,tp)	
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	
	end
end
