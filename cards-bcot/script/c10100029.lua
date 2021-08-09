--Ko-Koro, Village of Ice
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--No attacks
  --Apply flag effects for tracking
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CANNOT_ATTACK)
  e1:SetRange(LOCATION_SZONE)
  e1:SetTargetRange(0,LOCATION_MZONE)
  e1:SetCondition(s.condition1)
  e1:SetTarget(s.target1)
  c:RegisterEffect(e1)
  --Destruction/targeting protection
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD)
  e2a:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
  e2a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2a:SetRange(LOCATION_SZONE)
	e2a:SetTargetRange(LOCATION_MZONE,0)
  e2a:SetCondition(s.condition2)
	e2a:SetValue(aux.indoval)
	c:RegisterEffect(e2a)
	local e2b=e2a:Clone()
  e2b:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e2b:SetValue(aux.tgoval)
  c:RegisterEffect(e2b)
  --Negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
  e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	c:RegisterEffect(e3)
  
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
  aux.GlobalCheck(s,function()
    --Attacks this turn
		s[0]=0
		s[1]=0
    --Attacks last turn
		s[2]=0
		s[3]=0
    --Destroyed/banished monsters this turn (SP to EP)
    s[4]=0
    s[5]=0
    --Destroyed/banished monsters last turn (SP to EP +DP of this turn)
    s[6]=0
    s[7]=0
    --Destroyed/banished monsters two turns ago (SP to EP +DP of last turn)
    s[8]=0
    s[9]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(s.checkop_attacks)
		Duel.RegisterEffect(ge1,0)
    local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_DESTROYED)
		ge2:SetOperation(s.checkop_leave)
		Duel.RegisterEffect(ge2,0)
    local ge3=Effect.CreateEffect(c)
    ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge3:SetCode(EVENT_REMOVE)
    ge3:SetOperation(s.checkop_leave)
    Duel.RegisterEffect(ge3,0)
    --At the end of each opponent's BP, flag the monsters that did not attack
    local ge4=Effect.CreateEffect(c)
    ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge4:SetCode(EVENT_PHASE+PHASE_BATTLE)
    ge4:SetCountLimit(1)
    ge4:SetOperation(s.checkop_attackflags)
    Duel.RegisterEffect(ge4,0)
		aux.AddValuesReset(function()
			for p=0,1 do
        s[p+2]=s[p]
        s[p]=0
        s[4+p+4]=s[4+p+2]
        s[4+p+2]=s[4+p]
        s[4+p]=0
      end
		end)
	end)
end
function s.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function s.checkop_attacks(e,tp,eg,ep,ev,re,r,rp)
	s[ep]=s[ep]+1
end
function s.checkfilter_leave(c,p)
  return c:IsPreviousControler(p) and c:IsReason(REASON_EFFECT)
end
function s.checkop_leave(e,tp,eg,ep,ev,re,r,rp)
  if rp==tp then
    local ct=eg:FilterCount(s.checkfilter_leave,nil,1-tp)
    if Duel.GetCurrentPhase()==PHASE_DRAW then
      s[4+tp+2]=s[4+tp+2]+ct
    else
      s[4+tp]=s[4+tp]+ct
    end
  end
end
function s.checkop_attackflags(e,tp,eg,ep,ev,re,r,rp)
  if tp==Duel.GetTurnPlayer() then return end
  Debug.Message("lessgo")
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
  for tc in aux.Next(g) do
    tc:ResetFlagEffect(id)
    if tc:IsFaceup() and tc:GetAttackedCount()==0 then
      Debug.Message(tc:GetCode())
      tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
    end
  end
end

function s.filter(c)
  return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.condition(e)
  local tp=e:GetHandlerPlayer()
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
  return g:GetCount()>0 and g:GetCount()==g:FilterCount(s.filter,nil)
end
function s.condition1(e)
  local tp=e:GetHandlerPlayer()
  return s.condition(e) and s[tp+2]==0
end
function s.target1(e,c)
  return c:GetFlagEffect(id)==0
end
function s.condition2(e)
  local tp=e:GetHandlerPlayer()
  local sum
  if Duel.GetTurnPlayer()~=tp then
    sum=s[4+tp]+s[4+tp+2]
  elseif Duel.GetCurrentPhase()==PHASE_DRAW then
    sum=s[4+tp]+s[4+tp+2]+s[4+tp+4]
  else
    sum=s[4+tp]
  end
  return s.condition(e) and sum==0
end
function s.condition3(e)
  local tp=e:GetHandlerPlayer()
  return s.condition(e) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
end
function s.target3(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end