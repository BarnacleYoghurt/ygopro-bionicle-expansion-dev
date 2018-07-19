if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Krana Ja, Scout
function c10100213.initial_effect(c)
	--Equip
	local e1=bbts.krana_equip(c)
	c:RegisterEffect(e1)
	--Scout
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(bbts.krana_condition_equipped)
	e2:SetTarget(c10100213.target2)
	e2:SetOperation(c10100213.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Revive
	local e3=bbts.krana_revive(c)
	c:RegisterEffect(e3)
	--Summon
	local e4=bbts.krana_summon(c)
	c:RegisterEffect(e4)
end
function c10100213.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c10100213.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15c))
		e1:SetValue(c10100213.value2_1)
		e1:SetReset(RESET_PHASE+PHASE_MAIN2,2)
		e1:SetLabel(Duel.GetTurnCount()+1)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10100213.value2_1(e,re)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnCount()==e:GetLabel() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and re:GetHandler() == e:GetLabelObject()
end