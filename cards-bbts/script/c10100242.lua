--Bohrok Servant
function c10100242.initial_effect(c)
  --fusion material
	c:EnableReviveLimit()
  aux.AddFusionProcFun2(c, aux.FilterBoolFunction(Card.IsFusionSetCard,0x15d), c10100242.genFilter0(c), true)
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
	c:RegisterEffect(e2)
end
--Generate filter function that can discriminate by owner
function c10100242.genFilter0(sc)
	return function(c) 
    local tp=sc:GetControler()
    return c:GetOwner()==1-tp 
  end
end
function c10100242.value1(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c10100242.filter2a(c,fc)
	return c:IsFusionSetCard(0x15d) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c10100242.filter2b,fc:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,c,fc)
end
function c10100242.filter2b(c,fc)
	return c10100242.genFilter0(fc)(c) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function c10100242.condition2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100242.filter2a,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,c)
end
function c10100242.operation2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100242.filter2a,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c10100242.filter2b,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,1,g:GetFirst(),c)
  g:Merge(g2)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
  --ATK/DEF
  local tc=g2:GetFirst()
  local atk=tc:GetBaseAttack()
  local def=tc:GetBaseDefense()
  if atk<0 then atk=0 end
  if def<0 then def=0 end
  Debug.Message(atk)
	if atk~=0 or def~=0 then
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
end