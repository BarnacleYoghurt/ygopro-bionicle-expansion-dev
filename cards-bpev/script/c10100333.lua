if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Bohrok Nuhvok-Kal
local s,id=GetID()
function s.initial_effect(c)
  Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
  c:EnableReviveLimit()
  --Xyz Material
  Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb08),4,2)
  --Materials to Deck
  local e1=bpev.bohrok_kal_xmat(c)
  c:RegisterEffect(e1)
  --Attach
  local e2=bpev.bohrok_kal_attach(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
  --Gravity
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCost(Cost.DetachFromSelf(2,s.cost3max,function(e,g) e:SetLabel(#g) end))
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
s.listed_series={0xb08,0xb09}
function s.filter3(c,zones,offset)
  return zones&(1<<(offset+c:GetSequence()))~=0
end
function s.cost3max(e)
  local zones=Duel.GetLocationCount(0,LOCATION_MZONE)+Duel.GetLocationCount(0,LOCATION_SZONE) --P0 open zones
  zones=zones+Duel.GetLocationCount(1,LOCATION_MZONE)+Duel.GetLocationCount(1,LOCATION_SZONE) --P1 open zones
  zones=zones+Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD) --Occupied zones
  -- occupied includes cards in Field Zone and EMZ, so subtract those again
  zones=zones-Duel.GetMatchingGroupCount(function(c) return c:GetSequence()>4 end,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
  return math.min(e:GetHandler():GetOverlayCount(),zones)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local function locked_zones(p)
    -- Somewhat convoluted computation of which zones are locked on the field of player p.
    -- Basically, this is the zones that are not open but also do not have a card in them.

    local offset=(p==tp) and 0 or 16
    -- Get the zones that are unavailable (1 in LocationCount flag), then filter out the
    -- ones that are actually occupied.
    local locked_mz=select(2,Duel.GetLocationCount(p,LOCATION_MZONE))
      &~(Duel.GetFieldGroup(p,LOCATION_MZONE,0):GetBitwiseOr(function(c) return 1<<c:GetSequence() end))
    local locked_sz=select(2,Duel.GetLocationCount(p,LOCATION_SZONE))
      &~(Duel.GetFieldGroup(p,LOCATION_SZONE,0):GetBitwiseOr(function(c) return 1<<c:GetSequence() end))
    -- Finally, shift according to row and player
    locked_mz=(locked_mz<<offset)
    locked_sz=(locked_sz<<(offset+8))
    return locked_mz|locked_sz
  end

  -- Zones that cannot be selected: EMZ, Field Zone, already locked
  local ez_own=(1<<5)|(1<<6)
  local ez_opp=(1<<21)|(1<<22)
  local fz_own=(1<<13)
  local fz_opp=(1<<29)
  local lk_own=locked_zones(tp)
  local lk_opp=locked_zones(1-tp)

  local dis=Duel.SelectFieldZone(tp,e:GetLabel(),LOCATION_ONFIELD,LOCATION_ONFIELD,ez_own|ez_opp|fz_own|fz_opp|lk_own|lk_opp)
  Duel.Hint(HINT_ZONE,tp,dis)
  Duel.SetTargetParam(dis)
  Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_EITHER,LOCATION_ONFIELD)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local zones=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
  --Get cards from zones
  local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(s.filter3,nil,zones,0)
        +Duel.GetFieldGroup(tp,LOCATION_SZONE,0):Filter(s.filter3,nil,zones,8)
        +Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(s.filter3,nil,zones,16)
        +Duel.GetFieldGroup(tp,0,LOCATION_SZONE):Filter(s.filter3,nil,zones,24)
  --Bounce
  if #g>0 then 
    Duel.SendtoHand(g,nil,REASON_EFFECT)
  end
  --Lock free zones
  local used=select(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
            +(select(2,Duel.GetLocationCount(tp,LOCATION_SZONE))<<8)
            +(select(2,Duel.GetLocationCount(1-tp,LOCATION_MZONE))<<16)
            +(select(2,Duel.GetLocationCount(1-tp,LOCATION_SZONE))<<24)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_DISABLE_FIELD)
  e1:SetOperation(function(e) return e:GetLabel() end)
  e1:SetLabel(zones&~used)
  e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
  Duel.RegisterEffect(e1,tp)
end