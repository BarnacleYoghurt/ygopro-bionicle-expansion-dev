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
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetCondition(s.condition2)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
  
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
		aux.AddValuesReset(function()
			local p=Duel.GetTurnPlayer()
			s[p+2]=s[p]
			s[p]=0
      s[4+p+4]=s[4+p+2]
      s[4+p+2]=s[4+p]
			s[4+p]=0
      Debug.Message("Reset done")
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
      Debug.Message("count up")
      s[4+tp]=s[4+tp]+ct
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
    Debug.Message("opp turn")
    sum=s[4+tp]+s[4+tp+2]
    Debug.Message(sum)
  elseif Duel.GetCurrentPhase()==PHASE_DRAW then
    Debug.Message("own turn - pre-SP")
    sum=s[4+tp]+s[4+tp+2]+s[4+tp+4]
    Debug.Message(sum)
  else
    Debug.Message("own turn - post-SP")
    sum=s[4+tp]
    Debug.Message(sum)
  end
  return s.condition(e) and sum==0
end
