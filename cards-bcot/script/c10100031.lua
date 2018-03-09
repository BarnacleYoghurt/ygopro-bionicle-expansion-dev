--C.C. Matoran Kapura
function c10100031.initial_effect(c)
	--Burn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100031,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c10100031.target1)
	e1:SetOperation(c10100031.operation1)
	e1:SetCountLimit(2,10100031)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100031,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(-1)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(c10100031.condition2)
	e2:SetTarget(c10100031.target2)
	e2:SetOperation(c10100031.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c10100031.operation3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end
--e1 - Burn
function c10100031.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetAttack())
end
function c10100031.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,e:GetHandler():GetAttack(),REASON_EFFECT)
end
--e2 - Draw
function c10100031.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(10100031)~=0
end
function c10100031.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10100031.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c10100031.operation3(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10100031,RESET_PHASE+PHASE_END,0,1)
end