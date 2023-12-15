if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Bohrok Gahlok
function s.initial_effect(c)
	--flip
	local e1=bbts.bohrok_flip(c)
	c:RegisterEffect(e1)
	--be unpredictable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	if #g==0 then return false end
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
			return Duel.IsExistingMatchingCard(Card.IsNegatableMonster,tp,0,LOCATION_MZONE,1,nil)
		elseif top:IsType(TYPE_TRAP) then
			return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
		else 
			return false
		end
	end
	if top:IsType(TYPE_MONSTER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		e:SetLabel(TYPE_MONSTER)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	elseif top:IsType(TYPE_SPELL) then
		local tg=Duel.GetMatchingGroup(Card.IsNegatableMonster,tp,0,LOCATION_MZONE,nil)
		e:SetLabel(TYPE_SPELL)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,1,0,0)
	elseif top:IsType(TYPE_TRAP) then
		local tg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		e:SetLabel(TYPE_TRAP)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
	end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=e:GetLabel()
	if opt==TYPE_MONSTER then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then 
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif opt==TYPE_SPELL then
		local g=Duel.SelectMatchingCard(tp,Card.IsNegatableMonster,tp,0,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	elseif opt==TYPE_TRAP then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if #g>0 then
			local sc=g:RandomSelect(tp,1):GetFirst()
			Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)

			sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCondition(s.condition2_1)
			e1:SetOperation(s.operation2_1)
			e1:SetLabelObject(sc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			Duel.RegisterEffect(e1,tp)
		end
	end
	--To deck
	local e1=bbts.bohrok_shuffledelayed(c)
	e1:SetDescription(aux.Stringid(id,2))
	Duel.RegisterEffect(e1,tp)
end
function s.condition2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)==0 then
		e:Reset()
		return false
	else
		return true
	end
end
function s.operation2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end
