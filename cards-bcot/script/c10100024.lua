--The Great Temple,Kini-Nui
function c10100024.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Protect Equips
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(c10100024.target1)
	e1:SetValue(c10100024.value1)
	c:RegisterEffect(e1) 
	--Exchange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100024,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10100024.target2)
	e2:SetOperation(c10100024.operation2)
	c:RegisterEffect(e2)
end
--e1 - Protect Equips
function c10100024.value1(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c10100024.target1(e,c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
--e2 - Exchange
function c10100024.filter2(c)
	return c:IsSetCard(0x158) and c:IsType(TYPE_EQUIP) and c:IsDiscardable()
end
function c10100024.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100024.filter2,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10100024.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.IsExistingMatchingCard(c10100024.filter2,tp,LOCATION_HAND,0,1,nil) and Duel.DiscardHand(tp,c10100024.filter2,1,1,REASON_EFFECT+REASON_DISCARD) then
		Duel.BreakEffect()
		Duel.Draw(p,d,REASON_EFFECT)
	end
end