--Bohrok Kaita Za
function c10100228.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCode3(c,10100201,10100203,10100204,true,true)
	c:EnableReviveLimit()
	--Equip Krana
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10100228.condition1)
	e1:SetTarget(c10100228.target1)
	e1:SetOperation(c10100228.operation1)
	c:RegisterEffect(e1)
end
function c10100228.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15d) and c:IsAbleToGrave()
end
function c10100228.condition1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c10100228.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c10100228.filter1,tp,LOCATION_DECK,0,1,nil) 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
	end
	local g=Duel.SelectMatchingCard(tp,c10100228.filter1,tp,LOCATION_DECK,0,1,3,nil)
	local g1=g:Select(1-tp,1,1,nil)
	--Put opponent's selection as first card in g1
	g:Sub(g1)
	g1:Merge(g)
	g1:KeepAlive()
	e:SetLabelObject(g1)
end
function c10100228.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g1=e:GetLabelObject()
	if g1 and g1:GetCount()>0 then
		local c=e:GetHandler()
		local ec=g1:GetFirst()
		Duel.Equip(tp,ec,c,true)
		g1:RemoveCard(ec)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
end