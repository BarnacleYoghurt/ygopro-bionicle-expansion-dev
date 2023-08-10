if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Nuva Symbol of Burning Courage
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --Search EP or Tahu
  local e1=bpev.nuva_symbol_search(c,10100001,aux.Stringid(id,2))
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Block effects
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(s.condition2)
	c:RegisterEffect(e2)	
  --Leave field
  local e3=bpev.nuva_symbol_punish(c,s.operation3)
  e3:SetDescription(aux.Stringid(id,1))
  c:RegisterEffect(e3)
end
function s.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xb0c) and c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function s.condition2(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and s.filter2(a,tp)) or (d and s.filter2(d,tp))
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SKIP_BP)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetTargetRange(1,0)
  if Duel.GetTurnPlayer()==tp then
    e1:SetLabel(Duel.GetTurnCount())
    e1:SetCondition(s.condition3_1)
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
  else
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
  end
  Duel.RegisterEffect(e1,tp)
end
function s.condition3_1(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end