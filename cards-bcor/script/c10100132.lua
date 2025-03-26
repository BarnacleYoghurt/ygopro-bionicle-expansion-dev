if not bcor then
	Duel.LoadScript("util-bcor.lua")
end
--Lightning Bug, Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=bcor.rahi_insect_spsum(c,s.target1,s.operation1)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		--Count activations ...
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(s.checkcon)
		ge1:SetOperation(s.checkop1)
		Duel.RegisterEffect(ge1,0)
		--... but uncount them if they are negated
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetCondition(s.checkcon)
		ge2:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge2,0)
	end)
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsMonsterEffect() and rc:IsRelateToEffect(re) and loc==LOCATION_MZONE
end
function s.checkop1(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1)
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ct=rc:GetFlagEffect(id)
	--roundabout way to decrement a flag count
	rc:ResetFlagEffect(id)
	for i=1,ct-1 do
		rc:RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1)
	end
end
function s.filter1(c)
	return c:IsNegatableMonster() and c:HasFlagEffect(id)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end -- optional actions do not affect activatability
	Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_MZONE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.filter1,1-tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
		local g=Duel.SelectMatchingCard(tp,s.filter1,1-tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			g:GetFirst():NegateEffects(e:GetHandler(),RESET_PHASE+PHASE_END)
		end
	end
end
