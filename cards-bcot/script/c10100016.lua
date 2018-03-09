--Quest for the Masks
function c10100016.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Deck->Grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100016,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c10100016.condition1)
	e1:SetTarget(c10100016.target1)
	e1:SetOperation(c10100016.operation1)
	c:RegisterEffect(e1)
	--Grave->Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100016,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c10100016.cost2)
	e2:SetTarget(c10100016.target2)
	e2:SetOperation(c10100016.operation2)
	c:RegisterEffect(e2)
end
--e1 - Deck->Grave
function c10100016.filter1a(c,tp)
	return c:GetPreviousControler()~=tp
end
function c10100016.filter1b(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x158) and c:IsAbleToGrave()
end
function c10100016.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:IsExists(c10100016.filter1a,1,nil,tp)
end
function c10100016.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100016.filter1b,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10100016.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10100016.filter1b,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--e2 - Grave->Hand
function c10100016.filter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x158) and c:IsAbleToHand()
end
function c10100016.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c10100016.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100016.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c10100016.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100016.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end