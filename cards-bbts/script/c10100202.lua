if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Gahlok
function c10100202.initial_effect(c)
	--flip
  local e1=bbts.bohrok_flip(c)
  c:RegisterEffect(e1)
	--be unpredictable
	local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
  e2:SetDescription(aux.Stringid(10100202,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10100202.target2)
	e2:SetOperation(c10100202.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function c10100202.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	if g:GetCount()==0 then return false end
	local top=g:GetFirst()
	local tc=g:GetNext()
	while tc do
		if tc:GetSequence()>top:GetSequence() then top=tc end
		tc=g:GetNext()
	end
	if chk==0 then 
		if bit.band(top:GetType(),0x1)==0x1 then
			return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
		elseif bit.band(top:GetType(),0x2)==0x2 then
			return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		elseif bit.band(top:GetType(),0x4) == 0x4 then
			return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
		else 
			return false
		end
	end
	if bit.band(top:GetType(),0x1) == 0x1 then
		local tg=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	elseif bit.band(top:GetType(),0x2) == 0x2 then
		local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DISABLE,tg,1,0,0)
	elseif bit.band(top:GetType(),0x4) then
		local tg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
	end
	e:SetLabel(top:GetType())
end
function c10100202.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(e:GetLabel(),0x1) == 0x1 then
		local tc=Duel.GetFirstTarget()
		if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif bit.band(e:GetLabel(),0x2) == 0x2 then
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		if c:IsRelateToEffect(e) and g:GetCount()>0 then
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
      e3:SetValue(0)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	elseif bit.band(e:GetLabel(),0x4) == 0x4 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(tp,1)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
  --To deck
  local e1=bbts.bohrok_shuffledelayed(c)
  Duel.RegisterEffect(e1,tp)
end