--C.C. Matoran Kapura
local s,id=GetID()
function s.initial_effect(c)
	--Kapura'd
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.value1)
	e1:SetCondition(s.condition1)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
  if not s.global_check then
		s.global_check=true
		s[0]=0
		s[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.g_operation1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(s.g_operation2)
		Duel.RegisterEffect(ge2,0)
	end
end

function s.value1(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function s.condition1(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function s.condition2_1(e,tp,eg,ep,ev,re,r,rp)
	return s[tp]>0
end
function s.target2_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,s[tp]) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(s[tp])
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,s[tp])
end
function s.operation2_1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCondition(s.condition2_1)
    e1:SetTarget(s.target2_1)
    e1:SetOperation(s.operation2_1)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function s.g_filter1(c,p)
  return c:IsSetCard(0x1157) and c:GetSummonPlayer()==p
end
function s.g_operation1(e,tp,eg,ep,ev,re,r,rp)
  s[tp]=s[tp]+eg:FilterCount(s.g_filter1,nil,tp)
  s[1-tp]=s[1-tp]+eg:FilterCount(s.g_filter1,nil,1-tp)
end
function s.g_operation2(e,tp,eg,ep,ev,re,r,rp)
	s[0]=0
	s[1]=0
end
