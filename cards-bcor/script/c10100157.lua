--Mana Ko, Guardian Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Synchro Summon
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xb06),1,99,Synchro.NonTuner(Card.IsSetCard,0xb06),1,99)
	c:EnableReviveLimit()
	--Control cannot switch
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e1)
	--Protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(function(e,c) return c~=e:GetHandler() end)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--Special Summon and banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(s.cost4)
	e3:SetTarget(s.target4)
	e3:SetOperation(s.operation4)
	e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
function s.filter4(c,e,tp)
	return c:IsSetCard(0xb06) and c:IsRace(RACE_FISH|RACE_SEASERPENT|RACE_AQUA) and c:IsLevelBelow(10)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rescon4(sg,e,tp,mg)
	return sg:GetSum(Card.GetLevel)<=10
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if lc>0 then
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then lc=1 end
		local rg=Duel.GetMatchingGroup(s.filter4,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		local g=aux.SelectUnselectGroup(rg,e,tp,1,lc,s.rescon4,1,tp,HINTMSG_SPSUMMON)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Hint(tp,HINT_SELECTMSG,HINTMSG_REMOVE)
			local bg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if #bg>0 then
				Duel.HintSelection(bg,true)
				Duel.Remove(bg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end