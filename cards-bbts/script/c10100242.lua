--Bohrok Servant
function c10100242.initial_effect(c)
	c:SetSPSummonOnce(10100242)
  --fusion material
	c:EnableReviveLimit()
  aux.AddFusionProcFun2(c, c10100242.genFilter0a(c), c10100242.genFilter0b(c), true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10100242.value1)
	c:RegisterEffect(e1)	
  --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10100242.condition2)
	e2:SetOperation(c10100242.operation2)
  e2:SetValue(242)
	c:RegisterEffect(e2)
  --atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c10100242.condition3)
	e3:SetOperation(c10100242.operation3)
	c:RegisterEffect(e3)
end
--Generate filter functions that can discriminate by owner
function c10100242.genFilter0a(sc)
  return function(c)
    local tp=sc:GetControler()
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15d) and c:GetOwner()==tp 
  end
end
function c10100242.genFilter0b(sc)
	return function(c) 
    local tp=sc:GetControler()
    return c:IsType(TYPE_MONSTER) and c:GetOwner()==1-tp 
  end
end
function c10100242.value1(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c10100242.filter2(c,fc,ff)
	return ff(c) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function c10100242.condition2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100242.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c,c10100242.genFilter0a(c)) and Duel.IsExistingMatchingCard(c10100242.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c,c10100242.genFilter0b(c))
end
function c10100242.operation2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c10100242.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,c,c10100242.genFilter0a(c))
	local g2=Duel.SelectMatchingCard(tp,c10100242.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,c,c10100242.genFilter0b(c))
  g:Merge(g2)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c10100242.condition3(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+242
end
function c10100242.filter3(c,tp)
  return c:GetOwner()==1-tp
end
function c10100242.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local tc=g:Filter(aux.FilterBoolFunction(c10100242.filter3,tp),nil):GetFirst()
  local atk=tc:GetBaseAttack()
  local def=tc:GetBaseDefense()
  if atk<0 then atk=0 end
  if def<0 then def=0 end
	if atk~=0 or def~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    e2:SetValue(def)
		c:RegisterEffect(e2)
	end
end