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
		if top:IsType(TYPE_MONSTER) then
			return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
		elseif top:IsType(TYPE_SPELL) then
			return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		elseif top:IsType(TYPE_TRAP) then
			return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
		else 
			return false
		end
	end
	if top:IsType(TYPE_MONSTER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	elseif top:IsType(TYPE_SPELL) then
		local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DISABLE,tg,1,0,0)
	elseif top:IsType(TYPE_TRAP) then
		local tg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
	end
end
function c10100202.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	if g:GetCount()==0 then return false end
	local top=g:GetFirst()
	local tc=g:GetNext()
	while tc do
		if tc:GetSequence()>top:GetSequence() then top=tc end
		tc=g:GetNext()
	end
  
  local c=e:GetHandler()
	if top:IsType(TYPE_MONSTER) then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then 
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif top:IsType(TYPE_SPELL) then
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
      if tc:IsType(TYPE_EFFECT) then
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
      end
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
      e3:SetValue(0)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	elseif top:IsType(TYPE_TRAP) then
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