if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Bohrok Kaita Za
function s.initial_effect(c)
	--Fusion Material
	Fusion.AddProcMix(c,true,true,10100201,10100203,10100204)
	c:EnableReviveLimit()
	--Search Krana
	local e1=bbts.bohrokkaita_krana(c)
	c:RegisterEffect(e1)
	--Gain ATK
	local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(s.cost2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function s.filter2(c)
	return c:IsSetCard(0xb08) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,3,nil)
	e:SetLabel(Duel.Remove(g,POS_FACEUP,REASON_COST))
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  local ct=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
    if ct>1 then
      local e2=Effect.CreateEffect(c)
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_IMMUNE_EFFECT)
      e2:SetValue(s.value2_2)
      e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
      c:RegisterEffect(e2)
    end
	end
end
function s.value2_2(e,re)
	return e:GetHandler()~=re:GetOwner()
end