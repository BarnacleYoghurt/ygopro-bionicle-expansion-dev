if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Nuhvok Va
function c10100218.initial_effect(c)
	--special summon
	local e1=bbts.bohrokva_selfss(c,10100203)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10100218.cost2)
	e2:SetTarget(c10100218.target2)
	e2:SetOperation(c10100218.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Return
	local e3=bbts.bohrokva_shuffle(c)
	c:RegisterEffect(e3)
end
function c10100218.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c10100218.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10100218.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end