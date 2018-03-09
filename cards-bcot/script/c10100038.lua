--The Chronicler's Company
function c10100038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100038,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10100038.condition2)
	e2:SetTarget(c10100038.target2)
	e2:SetOperation(c10100038.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Effect Immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100038,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1157))
	e3:SetCondition(c10100038.condition3)
	e3:SetCountLimit(1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100038,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10100038.condition4)
	e4:SetTarget(c10100038.target4)
	e4:SetOperation(c10100038.operation4)
	c:RegisterEffect(e4)
	--Bounce
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10100038,3))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetCondition(c10100038.condition5)
	e5:SetTarget(c10100038.target5)
	e5:SetOperation(c10100038.operation5)
	c:RegisterEffect(e5)
	--Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10100038,4))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c10100038.condition6)
	e6:SetCost(cost6)
	e6:SetTarget(c10100038.target6)
	e6:SetOperation(c10100038.operation6)
	e6:SetCountLimit(1,10100038+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e6)
end
--Shared
function c10100038.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1157)
end
--e2 - Special Summon
function c10100038.filter2(c,e,tp)
	return c:IsSetCard(0x1157) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100038.condition2(e)
	return Duel.IsExistingMatchingCard(c10100038.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c10100038.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100038.filter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,nil,1,0,0)
end
function c10100038.operation2(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(c10100038.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100038.filter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e3 - Effect Immune
function c10100038.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100038.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,2,nil)
end
--e4 - Draw
function c10100038.filter4(c,e,tp)
	return c:GetControler()==tp and c:IsSetCard(0x1157)
end
function c10100038.condition4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100038.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,3,nil) and eg:IsExists(c10100038.filter4,1,nil,e,tp)
end
function c10100038.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10100038.operation4(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c10100038.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,3,nil) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--e5 - Bounce
function c10100038.filter5(c)
	return c:IsFaceup() and c:IsSetCard(0x1157) and c:IsAbleToHand()
end
function c10100038.condition5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100038.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,4,nil)
end
function c10100038.target5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return  Duel.IsExistingTarget(c10100038.filter5,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g1=Duel.SelectTarget(tp,c10100038.filter5,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsIsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c10100038.operation5(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c10100038.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,4,nil) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
--e6 - Destroy
function c10100038.filter6(c)
	return c:IsDestructable() and not c:IsSetCard(0x1157)
end
function c10100038.condition6(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100038.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,5,nil)
end
function cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10100038.target6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100038.filter6,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c10100038.filter6,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c10100038.operation6(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c10100038.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,5,nil) then return end
	local sg=Duel.GetMatchingGroup(c10100038.filter6,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
