--Dimnished Matoran Nui
function c10100047.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot SS by other ways
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10100047.condition1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100047,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c10100047.cost2)
	e2:SetTarget(c10100047.target2)
	e2:SetOperation(c10100047.operation2)
	c:RegisterEffect(e2)
	--When leave field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100047,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(c10100047.target3)
	e3:SetOperation(c10100047.operation3)
	c:RegisterEffect(e3)
end
--e1 - Special Summon
function c10100047.filter1(c)
	return c:IsSetCard(0x157) and c:GetLevel()==2
end
function c10100047.condition1(e,c)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(c10100047.filter1,c:GetControler(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=6
end
--e2 - Destroy
function c10100047.filter2(c)
	return c:GetLevel()==2
end
function c10100047.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c10100047.filter2,1,nil) and e:GetHandler():IsReleasable() end
	local sg=Duel.SelectReleaseGroup(tp,c10100047.filter2,1,1,nil)
	sg:AddCard(e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c10100047.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
		return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10100047.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
--e3 - When leave field
function c10100047.filter3(c,e,tp)
	return c:IsSetCard(0x157) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100047.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2 
		and Duel.IsExistingMatchingCard(c10100047.filter2,tp,LOCATION_GRAVE,0,3,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_GRAVE)
end
function c10100047.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100047.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end