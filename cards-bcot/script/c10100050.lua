--Suva Kaita
function c10100050.initial_effect(c)
	--Special Summon from Grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100050,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c10100050.condition1)
	e1:SetTarget(c10100050.target1)
	e1:SetOperation(c10100050.operation1)
	e1:SetCountLimit(1,10100050)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	--Special Summon from Banished
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100050,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c10100050.cost2)
	e2:SetTarget(c10100050.target2)
	e2:SetOperation(c10100050.operation2)
	e2:SetCountLimit(1,10100050)
	c:RegisterEffect(e2)
end
--e1 - Special Summon from Grave
function c10100050.filter1a(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x155)
end
function c10100050.filter1b(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x155) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100050.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c10100050.filter1a,tp,LOCATION_MZONE,0,1,nil)
end
function c10100050.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10100050.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10100050.filter1b,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10100050.filter1b,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,g,1,0,0)
end
function c10100050.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if tc and c10100050.filter1b(tc,e,tp) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			Duel.BreakEffect()
			print(e:GetHandler():GetCode())
			print(e:GetHandler():GetBattlePosition())
			if Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE) then
				print(e:GetHandler():GetBattlePosition())
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(tc:GetLevel())
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e:GetHandler():RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CHANGE_CODE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(tc:GetCode())
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e:GetHandler():RegisterEffect(e2)
			end
		end
	end
end
--e2 - Special Summon from Banished
function c10100050.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x155) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100050.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10100050.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100050.filter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,nil,1,0,0)
end
function c10100050.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100050.filter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
