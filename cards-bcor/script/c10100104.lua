--Muaka, Tiger Rahi
function c10100104.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Indestructible
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10100104.condition1)
	e1:SetTarget(c10100104.target1)
	e1:SetValue(c10100104.value1)
	c:RegisterEffect(e1)
	--Gain LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100104,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c10100104.condition2)
	e2:SetTarget(c10100104.target2)
	e2:SetOperation(c10100104.operation2)
	c:RegisterEffect(e2)
end
function c10100104.value1(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c10100104.condition1(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x15a) and tc:IsRace(RACE_BEAST) and tc:GetLevel()==7
end
function c10100104.target1(e,c)
	return c:GetSequence()>5
end
function c10100104.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsSetCard(0x15a) and rc:IsFaceup() and rc:IsControler(tp)
end
function c10100104.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst():GetBattleTarget()
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c10100104.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
