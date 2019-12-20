--Bohrok Servant
function c10100242.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)	
  --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetCondition(c10100242.condition2)
	e2:SetOperation(c10100242.operation2)
	c:RegisterEffect(e2)
end
function c10100242.filter2a(c,fc,tp)
	return c:IsFusionSetCard(0x15d) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10100242.filter2b,fc:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,c,fc,tp)
end
function c10100242.filter2b(c,fc,tp)
	return c:GetOwner()==1-tp  and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function c10100242.condition2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100242.filter2a,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,c,tp)
end
function c10100242.operation2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100242.filter2a,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c10100242.filter2b,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,g:GetFirst(),c,tp)
  g:Merge(g2)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
  --ATK/DEF
  local tc=g2:GetFirst()
  local atk=math.max(tc:GetBaseAttack(), 0)
  local def=math.max(tc:GetBaseDefense(), 0)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_BASE_ATTACK)
  e1:SetValue(atk)
  e1:SetReset(RESET_EVENT+0xff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_SET_BASE_DEFENSE)
  e2:SetValue(def)
  c:RegisterEffect(e2)
end