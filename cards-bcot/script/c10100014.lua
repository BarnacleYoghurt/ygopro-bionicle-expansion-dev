--Toa Kaita Mata Wairuha
function c10100014.initial_effect(c)
	aux.AddXyzProcedure(c,c10100014.filter0,6,3)
	c:EnableReviveLimit()
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100014,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10100014.condition1)
	e1:SetTarget(c10100014.target1)
	e1:SetOperation(c10100014.operation1)
	c:RegisterEffect(e1)
	--Wisdom
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100014,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10100014.cost2)
	e2:SetTarget(c10100014.target2)
	e2:SetOperation(c10100014.operation2)
	c:RegisterEffect(e2)
end
--Summon Conditions
function c10100014.filter0(c)
	return c:IsSetCard(0x1155)
end
--e1 - Equip
function c10100014.filter1(c,ec)
	return c:IsType(TYPE_EQUIP)	and c:IsCode(10100049) and c:CheckEquipTarget(ec)
end
function c10100014.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c10100014.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10100014.filter1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c10100014.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,nil)
	local g=Duel.SelectMatchingCard(tp,c10100014.filter1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c)
	if g:GetCount()>0 and g:GetFirst():CheckEquipTarget(c) then
		Duel.Equip(tp,g:GetFirst(),c)
	end
end
--e2 - Wisdom
function c10100014.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10100014.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10100014.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	local g=g:RandomSelect(1-tp,1)
	g:Merge(Duel.GetDecktopGroup(1-tp,1))
	Duel.ConfirmCards(tp,g)
	local tc=g:GetFirst()
	local type=0
	local matching=false
	while tc do
		if type==0 then
			type=tc:GetType()
		elseif tc:IsType(type) then
			matching=true
		end
		tc=g:GetNext()
	end
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
	if matching and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then
		Duel.BreakEffect()
		local btc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
		if btc and Duel.Remove(btc,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end