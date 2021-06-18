--Ussal, Crab Rahi
local s,id=GetID()
function s.initial_effect(c)
  Pendulum.AddProcedure(c)
	--Pendulum from Grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(s.cost1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)	
	--To Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_PZONE,0)
	local tc=(g-e:GetHandler()):GetFirst()
	if chk==0 then return tc and tc:GetLeftScale()>1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(-1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD_DISABLE)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	tc:RegisterEffect(e2)
end
function s.operation1(e,tp,eg,ep,ev,re,rp)
  local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetDescription(aux.Stringid(id,3))
    e1:SetCode(EFFECT_SPSUMMON_PROC_G)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(s.condition1_1)
    e1:SetOperation(s.operation1_1)
    e1:SetValue(SUMMON_TYPE_PENDULUM)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
    
    if c:IsSequence(0) then
      c:RegisterEffect(e1)
    else
      local e2=Effect.CreateEffect(c)
      e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
      e2:SetRange(LOCATION_PZONE)
      e2:SetTargetRange(LOCATION_SZONE,0)
      e2:SetTarget(s.target1_2)
      e2:SetLabelObject(e1)
      e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
      c:RegisterEffect(e2)
    end
    
    --Destroy monsters summoned from GY in EP
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_PZONE)
    e3:SetTarget(s.target1_3)
    e3:SetOperation(s.operation1_3)
    e3:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD_DISABLE)
    e3:SetCountLimit(1)
    c:RegisterEffect(e3)
	end
end
function s.condition1_1(e,c,ischain,re,rp) --Duplicated from proc_pendulum
  if c==nil then return true end
  local tp=c:GetControler()
  local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if rpz==nil or c==rpz or (not inchain and Duel.GetFlagEffect(tp,10000000)>0) then return false end
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
  return g:IsExists(Pendulum.Filter,1,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
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
    tg=og:Filter(Card.IsLocation,nil,loc):Filter(Pendulum.Filter,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
  else
    tg=Duel.GetMatchingGroup(Pendulum.Filter,tp,loc,0,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
  end
  ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE))
  ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
  ft2=math.min(ft2,aux.CheckSummonGate(tp) or ft2)
  while true do
    local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE)
    local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
    local ct=ft
    if ct1>ft1 then ct=math.min(ct,ft1) end
    if ct2>ft2 then ct=math.min(ct,ft2) end
    local loc=0
    if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_GRAVE end
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
            else
              ft2=ft2+1
            end
            ft=ft+1
          end
        end
      end
      if tc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
        ft1=ft1-1
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
function s.filter1_3(c)
  return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsPreviousLocation(LOCATION_GRAVE)
end
function s.target1_3(e,tp,eg,ep,ev,re,rp,chk)
    return eg:IsExists(s.filter1_3,1,nil)
end
function s.operation1_3(e,tp,eg,ep,ev,re,rp)
    local g=eg:Filter(s.filter1_3,nil)
    for tc in aux.Next(g) do
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetCategory(CATEGORY_DESTROY)
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetCode(EVENT_PHASE+PHASE_END)
      e1:SetRange(LOCATION_MZONE)
      e1:SetTarget(s.target1_3_1)
      e1:SetOperation(s.operation1_3_1)
      e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
      e1:SetCountLimit(1)
      tc:RegisterEffect(e1)
    end
end
function s.target1_3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.operation1_3_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.filter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(4) and c~=e:GetHandler() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.filter3(c,e,tp)
	return c:IsSetCard(0xb06) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
