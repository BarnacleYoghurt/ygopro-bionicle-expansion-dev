--Golden Great Kanohi
function c10100052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10100052.target1)
	e1:SetOperation(c10100052.operation1)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10100052.condition2)
	c:RegisterEffect(e2)
	--Gain effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_SZONE)	
	e3:SetOperation(c10100052.operation3)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3a)
	local e3b=e3:Clone()
	e3b:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e3b)	
	local e3c=e3:Clone()
	e3c:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e3c)
	--Return
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100052,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10100052.condition4)
	e4:SetTarget(c10100052.target4)
	e4:SetOperation(c10100052.operation4)
	c:RegisterEffect(e4)
end
--e1 - Activate
function c10100052.filter1a(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x155) and Duel.GetMatchingGroup(c10100052.filter1b,tp,LOCATION_GRAVE,0,nil,c):GetClassCount(Card.GetCode)>=6 and not c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x158)
end
function c10100052.filter1b(c,ec)
	return c:IsSetCard(0x158) and c:CheckEquipTarget(ec)
end
function c10100052.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100052.filter1a,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.ClearTargetCard()
	Duel.SelectTarget(tp,c10100052.filter1a,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10100052.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local cg = Duel.SelectMatchingCard(tp,c10100052.filter1b,tp,LOCATION_GRAVE,0,6,6,nil,tc)
	cg:KeepAlive()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Remove(cg,POS_FACEUP,REASON_EFFECT) then
		e:SetLabelObject(cg)
		local cgc=cg:GetFirst()
		while cgc do				
			local code=cgc:GetOriginalCode()
			if cgc:IsLocation(LOCATION_REMOVED) then	
				if c:IsFaceup() and c:GetFlagEffect(code)==0 then
					local cid=c:CopyEffect(code, RESET_EVENT+0x1fe0000,1)
					c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,1)
					c:SetFlagEffectLabel(code,cid)
				end
			elseif c:GetFlagEffect(code)~=0 then		
				c:ResetEffect(c:GetFlagEffectLabel(code),RESET_COPY)
				c:ResetFlagEffect(code)
			end
			cgc=cg:GetNext()
		end
		Duel.Equip(tp,c,tc)
	end
end
--e2 - Equip Limit
function c10100052.condition2(e,c)
	return c:IsSetCard(0x155) and e:GetHandler():GetEquipTarget()==c
end
--e3 - Gain effects
function c10100052.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabelObject():GetLabelObject() then
		local wg=e:GetLabelObject():GetLabelObject()
		local wbc=wg:GetFirst()
		while wbc do				
			local code=wbc:GetOriginalCode()
			if wbc:IsLocation(LOCATION_REMOVED) then	
				if c:IsFaceup() and c:GetFlagEffect(code)==0 then
					local cid=c:CopyEffect(code, RESET_EVENT+0x1fe0000,1)
					c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,1)
					c:SetFlagEffectLabel(code,cid)
				end
			elseif c:GetFlagEffect(code)~=0 then		
				c:ResetEffect(c:GetFlagEffectLabel(code),RESET_COPY)
				c:ResetFlagEffect(code)
			end
			wbc=wg:GetNext()
		end
	end
end
--e4 - Return
function c10100052.filter4(c)
	return c:IsSetCard(0x158) and c:IsAbleToDeck()
end
function c10100052.condition4(e,c)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c10100052.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100052.filter4,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c10100052.operation4(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c10100052.filter4,p,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
	Duel.ShuffleDeck(p)
end
