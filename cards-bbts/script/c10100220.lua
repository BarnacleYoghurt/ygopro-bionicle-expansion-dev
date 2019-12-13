if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Kohrak Va
function c10100220.initial_effect(c)
	--special summon
	local e1 = bbts.bohrokva_selfss(c,10100205)
	c:RegisterEffect(e1)
	--Negate attack
	local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(10100220,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c10100220.condition2)
	e2:SetCost(c10100220.cost2)
	e2:SetOperation(c10100220.operation2)
	c:RegisterEffect(e2)
	--Return
	local e3 = bbts.bohrokva_shuffle(c)
	c:RegisterEffect(e3)
end
function c10100220.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c10100220.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(), REASON_COST)
end
function c10100220.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
