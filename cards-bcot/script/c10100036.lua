--C.C. Matoran Tamaru
function c10100036.initial_effect(c)
	--Return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100036,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c10100036.condition1)
	e1:SetTarget(c10100036.target1)
	e1:SetOperation(c10100036.operation1)
	e1:SetCountLimit(1,10100036)
	c:RegisterEffect(e1)
	--Swap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100036,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10100036.cost2)
	e2:SetTarget(c10100036.target2)
	e2:SetOperation(c10100036.operation2)
	e2:SetCountLimit(1,10100036)
	c:RegisterEffect(e2)
end
--e1 - Return
function c10100036.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and not (e:GetHandler():IsReason(REASON_BATTLE) or e:GetHandler():IsReason(REASON_EFFECT))
end
function c10100036.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 end
end
function c10100036.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
--e2 - Swap
function c10100036.filter2(c,e,tp)
	return c:GetLevel()==2 and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(10100036)
end
function c10100036.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c10100036.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c10100036.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100036.operation2(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100036.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
