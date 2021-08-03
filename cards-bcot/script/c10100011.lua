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
	--Lock drawn cards
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(s.condition2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	--Search
  local e3=bcot.kanohi_search(c,10100005)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return bcot.greatkanohi_con(e) and ep==1-tp
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  for tc in aux.Next(eg) do
    local rct=1
		if Duel.GetTurnPlayer()~=tp then rct=2
		elseif Duel.GetCurrentPhase()==PHASE_END then rct=3 end
      
    tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,rct,0,aux.Stringid(id,1))
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PUBLIC)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,rct)
    tc:RegisterEffect(e1)
    local e2a=Effect.CreateEffect(c)
    e2a:SetType(EFFECT_TYPE_SINGLE)
    e2a:SetCode(EFFECT_CANNOT_TRIGGER)
    e2a:SetRange(LOCATION_HAND)
    e2a:SetCondition(s.condition2_2)
    e2a:SetValue(1)
    e2a:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
    tc:RegisterEffect(e2a)
    local e2b=e2a:Clone()
    e2b:SetCode(EFFECT_CANNOT_SSET)
    tc:RegisterEffect(e2b)
  end
end
function s.condition2_2(e) --TODO: "while you control this face-up card!"
  local c=e:GetHandler()
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsPublic() and c:GetFlagEffect(id)~=0
end