if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Lehvak
function c10100206.initial_effect(c)
	--flip
  local e1=bbts.bohrok_flip(c)
  c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10100206.condition2)
	e2:SetTarget(c10100206.target2)
	e2:SetOperation(c10100206.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function c10100206.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c10100206.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return c:IsPosition(POS_FACEUP_ATTACK) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) 
	end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10100206.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT) then
		if c:IsFaceup() then
			Duel.BreakEffect()
			Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		end
	end
end

