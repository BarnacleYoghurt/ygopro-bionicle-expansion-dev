--Ko-Koro, Village of Ice
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--No attacks
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
  e1:SetRange(LOCATION_SZONE)
  e1:SetTargetRange(0,1)
  e1:SetCondition(s.condition1)
  c:RegisterEffect(e1)
  --Protection
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
  
  aux.GlobalCheck(s,function()
    --Attacks this turn
		s[0]=0
		s[1]=0
    --Attacks last turn
		s[2]=0
		s[3]=0
    --Removed monsters + effect damage this turn (SP to EP)
    s[4]=0
    s[5]=0
    --Removed monsters + effect damage last turn (SP to EP +DP of this turn)
    s[6]=0
    s[7]=0
    --Removed monsters + effect damage two turns ago (SP to EP +DP of last turn)
    s[8]=0
    s[9]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(s.checkop_attacks)
		Duel.RegisterEffect(ge1,0)
    local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_LEAVE_FIELD)
		ge2:SetOperation(s.checkop_leave)
		Duel.RegisterEffect(ge2,0)
    local ge3=Effect.CreateEffect(c)
    ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge3:SetCode(EVENT_DAMAGE)
    ge3:SetOperation(s.checkop_damage)
    Duel.RegisterEffect(ge3,0)
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
function s.checkop_damage(e,tp,eg,ep,ev,re,r,rp)
  if ep~=tp and (r&REASON_EFFECT)~=0 then
    if Duel.GetCurrentPhase()==PHASE_DRAW then
      s[4+tp+2]=s[4+tp+2]+1
    else
      s[4+tp]=s[4+tp]+1
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
