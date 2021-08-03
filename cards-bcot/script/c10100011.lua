if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Great Kanohi Akaku
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Reveal drawn cards
	local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(s.condition2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
	c:RegisterEffect(e2)
  --Lock revealed cards
  local e3a=Effect.CreateEffect(c)
  e3a:SetType(EFFECT_TYPE_FIELD)
  e3a:SetCode(EFFECT_CANNOT_TRIGGER)
  e3a:SetRange(LOCATION_SZONE)
  e3a:SetTargetRange(0,LOCATION_HAND)
  e3a:SetTarget(s.target3)
  e3a:SetValue(1)
  c:RegisterEffect(e3a)
  local e3b=e3a:Clone()
  e3b:SetCode(EFFECT_CANNOT_SSET)
  c:RegisterEffect(e3b)
	--Search
  local e3=bcot.kanohi_search(c,10100005)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsControler(tp) and bcot.greatkanohi_con(e) and ep==1-tp
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  for tc in aux.Next(eg) do
    local rct=1
		if Duel.GetTurnPlayer()~=tp then rct=2
		elseif Duel.GetCurrentPhase()==PHASE_END then rct=3 end
      
    tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,rct,c:GetFieldID(),aux.Stringid(id,2))
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PUBLIC)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,rct)
    tc:RegisterEffect(e1)
  end
end
function s.target3(e,c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsPublic() and c:GetFlagEffectLabel(id)==e:GetHandler():GetFieldID()
end