--Tarakava, Lizard Rahi
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end
function s.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsRace(RACE_REPTILE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local _,bc=Duel.GetBattleMonster(tp)
	return bc and bc:IsRelateToBattle()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local _,bc=Duel.GetBattleMonster(tp)
	if chkc then return s.filter1(chkc,e,tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) end
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_SZONE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local _,bc=Duel.GetBattleMonster(tp)
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and bc and bc:IsRelateToBattle() then
			Duel.Destroy(bc,REASON_EFFECT)
		end
	end
end
