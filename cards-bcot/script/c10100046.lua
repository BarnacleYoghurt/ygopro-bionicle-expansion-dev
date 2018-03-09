--Dimnished Matoran Kaita
function c10100046.initial_effect(c)
	aux.AddXyzProcedure(c,c10100046.filter0,2,3)
	c:EnableReviveLimit()
	--Indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c10100046.condition1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Detach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100046,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10100046.cost2)
	e2:SetTarget(c10100046.target2)
	e2:SetOperation(c10100046.operation2)
	c:RegisterEffect(e2)
end
--Summoning Conditions
function c10100046.filter0(c)
	return c:IsSetCard(0x157)
end
--e1 - Indestructable
function c10100046.condition1(e)
	return e:GetHandler():GetOverlayCount()>0
end
--e2 - Detach
function c10100046.filter2WATER(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10100046.filter2WIND(c)
	return c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_WIND)
end
function c10100046.filter2LIGHTDARK(c,e,tp)
	return c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100046.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g1 = e:GetHandler():GetOverlayGroup()
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local g2 = e:GetHandler():GetOverlayGroup()
	local tc = g1:GetFirst()
	while tc do
		if not g2:IsContains(tc) then
			e:SetLabelObject(tc)
		end
		tc=g1:GetNext()
	end
end
function c10100046.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dm = e:GetLabelObject()
	if dm then
		if dm:IsAttribute(ATTRIBUTE_WATER) then	
			if chkc then return chkc:IsOnField() and c10100046.filter2WATER(chkc) and chkc~=e:GetHandler() end
			if chk==0 then return Duel.IsExistingTarget(c10100046.filter2WATER,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectTarget(tp,c10100046.filter2WATER,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		end
		if dm:IsAttribute(ATTRIBUTE_EARTH) then
			local dc = e:GetHandler():GetOverlayCount()>2 and 2 or e:GetHandler():GetOverlayCount()
			if chk==0 then return Duel.IsPlayerCanDraw(tp,dc) end
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(dc)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dc)
		end
		if dm:IsAttribute(ATTRIBUTE_WIND) then
			if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10100046.filter2WIND(chkc) end
			if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(c10100046.filter2WIND,tp,LOCATION_GRAVE,0,1,nil) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=Duel.SelectTarget(tp,c10100046.filter2WIND,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
		end
		if dm:IsAttribute(ATTRIBUTE_LIGHT) or dm:IsAttribute(ATTRIBUTE_DARK) then
			if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c10100046.filter2LIGHTDARK(chkc,e,tp) end
			if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c10100046.filter2LIGHTDARK,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectTarget(tp,c10100046.filter2LIGHTDARK,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
		end
	end
	return true
end
function c10100046.operation2(e,tp,eg,ep,ev,re,r,rp)
	local dm = e:GetLabelObject()
	if dm:IsAttribute(ATTRIBUTE_FIRE) then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(600)
			e2:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e2)
		end
	end
	if dm:IsAttribute(ATTRIBUTE_WATER) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
	if dm:IsAttribute(ATTRIBUTE_EARTH) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
	if dm:IsAttribute(ATTRIBUTE_WIND) then
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc then
			Duel.Overlay(c,Group.FromCards(tc))
		end
	end
	if dm:IsAttribute(ATTRIBUTE_LIGHT) or dm:IsAttribute(ATTRIBUTE_DARK) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end