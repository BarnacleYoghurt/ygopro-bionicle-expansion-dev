--Sand Tarakava, Lizard Rahi
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--To backrow
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	--Grant effect (therefore becomes Effect Monster)
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2a:SetRange(LOCATION_PZONE)
	e2a:SetTargetRange(LOCATION_MZONE,0)
	e2a:SetTarget(s.target2)
	e2a:SetLabelObject(e1)
	c:RegisterEffect(e2a)
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_FIELD)
	e2b:SetRange(LOCATION_PZONE)
	e2b:SetTargetRange(LOCATION_MZONE,0)
	e2b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2b:SetCode(EFFECT_ADD_TYPE)
	e2b:SetTarget(s.target2)
	e2b:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2b)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then
		Duel.SendtoGrave(c,REASON_RULE,nil,PLAYER_NONE)
	else
		if c:IsType(TYPE_PENDULUM) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		elseif Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			-- as a Continuous Spell
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_SPELL|TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+(RESETS_STANDARD-RESET_TURN_SET))
			c:RegisterEffect(e1)
		end
	end
end
function s.target2(e,c)
	return c:IsSetCard(0xb06) and c:IsRace(RACE_REPTILE) and (c:GetSequence()==0 or c:GetSequence()==4)
end