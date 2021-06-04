--Kuma-Nui, Rat Rahi
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xb06),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--Destroy S/T
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local op=0
	if g:FilterCount(Card.IsFacedown,nil)>0 then
		if g:FilterCount(Card.IsFaceup, nil)>0 then
			op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		else
			op=1
		end
	end
	if op==0 then
		Duel.Destroy(g:Filter(Card.IsFaceup,nil),REASON_EFFECT)
	else
		Duel.Destroy(g:Filter(Card.IsFacedown,nil),REASON_EFFECT)
	end
	Duel.BreakEffect()
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsControler,nil,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
