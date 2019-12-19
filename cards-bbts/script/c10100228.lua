if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Kaita Za
function c10100228.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCode3(c,10100201,10100203,10100204,true,true)
	c:EnableReviveLimit()
	--Search Krana
	local e1=bbts.bohrokkaita_krana(c)
	c:RegisterEffect(e1)
	--Gain ATK
	local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetDescription(aux.Stringid(10100228,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c10100228.cost2)
	e2:SetOperation(c10100228.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function c10100228.filter2(c)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c10100228.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c10100228.filter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	local g=Duel.SelectMatchingCard(tp,c10100228.filter2,tp,LOCATION_GRAVE,0,1,3,nil)
	e:SetLabel(Duel.Remove(g,POS_FACEUP,REASON_COST))
end
function c10100228.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  local ct=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
    if ct>1 then
      local e2=Effect.CreateEffect(c)
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_IMMUNE_EFFECT)
      e2:SetValue(c10100228.value2_2)
      e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      c:RegisterEffect(e2)
    end
	end
end
function c10100228.value2_2(e,re)
	return e:GetHandler()~=re:GetOwner()
end