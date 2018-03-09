--C.C. Matoran Taipu
function c10100033.initial_effect(c)
	--Raise ATK
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100033,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c10100033.cost1)
	e1:SetTarget(c10100033.target1)
	e1:SetOperation(c10100033.operation1)
	e1:SetCountLimit(1,10100033)
	c:RegisterEffect(e1)
end
--e1 - Raise ATK
function c10100033.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c10100033.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10100033.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100033.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10100033.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10100033.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
