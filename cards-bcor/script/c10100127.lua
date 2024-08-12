--Shore Turtle, Shelled Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(s.target1)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
function s.target1(e,c)
	return c:IsRace(RACE_FISH|RACE_SEASERPENT|RACE_AQUA) and c:IsSetCard(0xb06) and c:IsMonsterCard()
end
function s.filter2a(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb06) and c:IsAbleToRemoveAsCost()
end
function s.filter2b(c,e,tp)
	return c:IsRace(RACE_FISH|RACE_SEASERPENT|RACE_AQUA) and c:IsSetCard(0xb06) and c:IsType(TYPE_TUNER) and not c:IsCode(id)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
			and (c:IsLocation(LOCATION_MZONE) or Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil))
	end
	local g=Group.FromCards(c)
	if not c:IsLocation(LOCATION_MZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g:Merge(Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil))
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
