--Ga-Koro, Village of Water
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Extra lock
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.target1)
	c:RegisterEffect(e1)
  --Response block
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_CHAINING)
  e2:SetRange(LOCATION_FZONE)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
end
function s.target1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsAttribute(ATTRIBUTE_WATER))
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and Duel.GetCurrentChain()>1 and Duel.GetTurnPlayer()~=tp and ep==tp then
		Duel.SetChainLimit(s.limit2_1)
	end
end
function s.limit2_1(e,rp,tp)
	return tp==rp
end