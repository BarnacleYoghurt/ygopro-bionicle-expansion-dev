--Ussal, Crab Rahi
local s,id=GetID()
function s.initial_effect(c)
  Pendulum.AddProcedure(c)
	--Pendulum from Grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)	
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
function s.operation1(e,tp,eg,ep,ev,re,rp)
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,3))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EFFECT_SPSUMMON_PROC_G)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCondition(s.condition1_1)
  e1:SetOperation(s.operation1_1)
  e1:SetValue(SUMMON_TYPE_PENDULUM)
  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
  --Always register on left scale (while keeping it tied to this card)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,4))
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
  e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
  e2:SetRange(LOCATION_PZONE)
  e2:SetTargetRange(LOCATION_SZONE,0)
  e2:SetTarget(s.target1_2)
  e2:SetLabelObject(e1)
  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e2)
  c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.filter1_1(c,e,tp,lscale,rscale,lvchk)
  if c:IsLocation(LOCATION_GRAVE) then
    -- Duplicated from proc_pendulum
    -- Sadly cannot just use Pendulum.Filter, since that strictly rules out non-Pendulums outside the hand
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local lv=0
    if c.pendulum_level then
      lv=c.pendulum_level
    else
      lv=c:GetLevel()
    end
    return c:IsRace(RACE_BEAST|RACE_WINGEDBEAST) and c:IsSetCard(0xb06)
      and (lvchk or (lv>lscale and lv<rscale)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
      and not c:IsForbidden()
  else
    return Pendulum.Filter(c,e,tp,lscale,rscale,lvchk)
  end
end
function s.condition1_1(e,c,ischain,re,rp) --Duplicated from proc_pendulum
  if c==nil then return true end
  local tp=c:GetControler()
  local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if rpz==nil or c==rpz or (not inchain and Duel.GetFlagEffect(tp,10000000)>0) then return false end

  -- custom addition: only if the scales are this card and another Rahi
  if not ((c:GetFlagEffect(id)>0 and rpz:IsSetCard(0xb06)) or (rpz:GetFlagEffect(id)>0 and c:IsSetCard(0xb06))) then return false end

  local lscale=c:GetLeftScale()
  local rscale=rpz:GetRightScale()
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND+LOCATION_GRAVE end
  if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
  if loc==0 then return false end
  local g=nil
  if og then
    g=og:Filter(Card.IsLocation,nil,loc)
  else
    g=Duel.GetFieldGroup(tp,loc,0)
  end
  return g:IsExists(s.filter1_1,1,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
end
function s.operation1_1(e,tp,eg,ep,ev,re,r,rp,c,sg,inchain) --Duplicated from proc_pendulum
  local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  local lscale=c:GetLeftScale()
  local rscale=rpz:GetRightScale()
  local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
  local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
  local ft=Duel.GetUsableMZoneCount(tp)
  if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
    if ft1>0 then ft1=1 end
    if ft2>0 then ft2=1 end
    ft=1
  end
  local loc=0
  if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_GRAVE end
  if ft2>0 then loc=loc+LOCATION_EXTRA end
  local tg=nil
  if og then
    tg=og:Filter(Card.IsLocation,nil,loc):Filter(s.filter1_1,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
  else
    tg=Duel.GetMatchingGroup(s.filter1_1,tp,loc,0,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
  end
  ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE))
  ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
  ft2=math.min(ft2,aux.CheckSummonGate(tp) or ft2)
  local gy_sel=false
  while true do
    local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE)
    local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
    local ct=ft
    if ct1>ft1 then ct=math.min(ct,ft1) end
    if ct2>ft2 then ct=math.min(ct,ft2) end
    local loc=0
    if ft1>0 then
      loc=loc+LOCATION_HAND
      if not gy_sel then loc=loc+LOCATION_GRAVE end
    end
    if ft2>0 then loc=loc+LOCATION_EXTRA end
    local g=tg:Filter(Card.IsLocation,sg,loc)
    if #g==0 or ft==0 then break end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Group.SelectUnselect(g,sg,tp,#sg>0,Duel.IsSummonCancelable())
    if not tc then break end
    if sg:IsContains(tc) then
      sg:RemoveCard(tc)
      if tc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
        ft1=ft1+1
        if tc:IsLocation(LOCATION_GRAVE) then gy_sel=false end
      else
        ft2=ft2+1
      end
      ft=ft+1
    else
      sg:AddCard(tc)
      if c:IsHasEffect(511007000)~=nil or rpz:IsHasEffect(511007000)~=nil then
        if not Pendulum.Filter(tc,e,tp,lscale,rscale) then
          local pg=sg:Filter(aux.TRUE,tc)
          local ct0,ct3,ct4=#pg,pg:FilterCount(Card.IsLocation,nil,LOCATION_HAND),pg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
          sg:Sub(pg)
          ft1=ft1+ct3
          ft2=ft2+ct4
          ft=ft+ct0
        else
          local pg=sg:Filter(aux.NOT(Pendulum.Filter),nil,e,tp,lscale,rscale)
          sg:Sub(pg)
          if #pg>0 then
            if pg:GetFirst():IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
              ft1=ft1+1
              if pg:GetFirst():IsLocation(LOCATION_GRAVE) then gy_sel=false end
            else
              ft2=ft2+1
            end
            ft=ft+1
          end
        end
      end
      if tc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
        ft1=ft1-1
        if tc:IsLocation(LOCATION_GRAVE) then gy_sel=true end
      else
        ft2=ft2-1
      end
      ft=ft-1
    end
  end
  if #sg>0 then
    if not inchain then
      Duel.RegisterFlagEffect(tp,10000000,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
    end
    Duel.HintSelection(Group.FromCards(c))
    Duel.HintSelection(Group.FromCards(rpz))
  end
end
function s.target1_2(e,c)
  return c:IsLocation(LOCATION_PZONE) and c:IsSequence(0)
end
function s.filter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp):GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
      tc:NegateEffects(e:GetHandler())
    end
    Duel.SpecialSummonComplete()
  end
end
function s.filter3(c)
	return c:IsSetCard(0xb06) and c:IsRace(RACE_BEAST|RACE_WINGEDBEAST) and c:IsAbleToRemove()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
