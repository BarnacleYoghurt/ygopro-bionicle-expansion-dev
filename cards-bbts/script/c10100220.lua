if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Bohrok Kohrak Va
function s.initial_effect(c)
	--special summon
	local e1 = bbts.bohrokva_selfss(c,10100205)
	c:RegisterEffect(e1)
	--Negate attack
	local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.cost2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	--Return
	local e3 = bbts.bohrokva_shuffle(c)
	c:RegisterEffect(e3)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(), REASON_COST)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
    Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
