--Matoran Champion Hewkii
function c10100148.initial_effect(c)
	--Target Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(c10100148.value1)
	c:RegisterEffect(e1)
	--Not destroyed by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c10100148.value2)
	c:RegisterEffect(e2)
	--Murderize
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100148,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c10100148.condition3)
	e3:SetTarget(c10100148.target3)
	e3:SetOperation(c10100148.operation3)
	c:RegisterEffect(e3)
end
function c10100148.value1(e,c)
	return c:IsFaceup() and c:GetCode()~=10100148 and c:IsSetCard(0x157)
end
function c10100148.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x157)
end
function c10100148.value2(e,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100148.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) and bit.band(r,REASON_BATTLE)~=0
end
function c10100148.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget() and e:GetHandler():GetBattleTarget():IsAttackAbove(2000)
end
function c10100148.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetBattleTarget():IsRelateToBattle() and e:GetHandler():GetBattleTarget():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
	local dam=e:GetHandler():GetBattleTarget():GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c10100148.operation3(e,tp,eg,ep,ev,re,r,rp)
	local bt=e:GetHandler():GetBattleTarget()
	if bt:IsRelateToBattle() and Duel.Destroy(bt,REASON_EFFECT)~=0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
