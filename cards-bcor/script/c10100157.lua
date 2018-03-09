--Mana Ko, Guardian Rahi
function c10100157.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x15a),aux.NonTuner(Card.IsSetCard,0x15a),1)
	c:EnableReviveLimit()
	--Control cannot switch
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e1)
	--Halve ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetCondition(c10100157.condition2)
	e2:SetValue(c10100157.value2)
	c:RegisterEffect(e2)
	--Enable effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c10100157.value3)
	c:RegisterEffect(e3)
	--Summon Material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100157,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c10100157.condition4)
	e4:SetTarget(c10100157.target4)
	e4:SetOperation(c10100157.operation4)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--Protection
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetCondition(c10100157.condition5)
	e5:SetValue(aux.tgoval)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	local e5a=e5:Clone()
	e5a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5a:SetValue(c10100157.value5a)
	c:RegisterEffect(e5a)	
end
function c10100157.value2(e,c)
	return c:GetAttack()/2
end
function c10100157.condition2(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c10100157.filter3(c)
	return not c:IsType(TYPE_TUNER)
end
function c10100157.value3(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(c10100157.filter3,nil)
	e:SetLabel(ct)
	if ct==1 then
		e:SetLabelObject(g:Filter(c10100157.filter3,nil):GetFirst())
	elseif ct>1 then
	end
end
function c10100157.condition4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function c10100157.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject():GetLabelObject()
	if chk==0 then return tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function c10100157.operation4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=e:GetLabelObject():GetLabelObject()
	if tc and not tc:IsType(TYPE_TUNER) and tc:IsLocation(LOCATION_GRAVE) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100157.value5a(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c10100157.condition5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()>1
end