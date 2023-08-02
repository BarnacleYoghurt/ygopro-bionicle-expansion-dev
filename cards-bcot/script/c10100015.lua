--Coming of the Toa
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.spfilter)
end
s.listed_names={10100016}
s.listed_series={0x1b02,0xb02}
--Cannot Special Summon monsters with 2000 or more ATK, except Toa
function s.spfilter(c) --what the counter IGNORES
	return not c:IsAttackAbove(2000) or c:IsSetCard(0xb02)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se) --what you are not allowed to summon
	return not s.spfilter(c)
end

function s.create_rescon(cg,dn)
  --Based on 67331360 (Doll House), but extended to account for 3+ targets and multi-Attribute effects
  return function (sg,e,tp,mg)
    if dn and not aux.dncheck(sg,e,tp,mg) then return false end --Abort immediately if dn flag set and names not different
    
    local pools={}
    local mpool = Group.CreateGroup()
    local i=0
    for sc in aux.Next(sg) do
      local att=sc:GetAttribute()
      local fg = cg:Filter(Card.IsAttribute,nil,att)
      pools[i] = fg:Clone()
      for j=0,i-1 do
        for fc in aux.Next(fg) do
          if (pools[j]-Group.FromCards(fc)):GetCount()<=0 then
            pools[i]:RemoveCard(fc) --all choices that would empty a previous pool are discarded
          end
        end
      end
      if pools[i]:GetCount()<=0 then return false end --do we have any choices left?
      mpool:Merge(pools[i])
      i=i+1
    end
    return mpool:GetCount()>=sg:GetCount() --are there actually enough cards across all pools for all targets?
	end
end

function s.filter1a(c,e)
  return c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function s.filter1b(c,e,tp)
  return c:IsSetCard(0x1b02) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter1c(c,tid)
  return c:IsLocation(LOCATION_GRAVE) and c:GetTurnID()==tid and not c:IsReason(REASON_RETURN)
end
function s.filter1d(c)
  return c:IsCode(10100016) and not c:IsForbidden()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
  local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),3)
  local tg=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_GRAVE,0,nil,e)
  local cg=Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_DECK,0,nil,e,tp)
  local rescon=s.create_rescon(cg,true)
  if chk==0 then return ft>0 and aux.SelectUnselectGroup(tg,e,tp,1,1,rescon,0) end
  
  if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
  local g=aux.SelectUnselectGroup(tg,e,tp,1,ft,rescon,1,tp,HINTMSG_TARGET)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g:GetCount(),0,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tg=Duel.GetTargetCards(e) --Note: This seems to automatically check IsRelateToEffect, so if something got banished the target group shrinks silently
  local ct=tg:GetCount()
	if ct>0 then
    local rescon=s.create_rescon(tg,false)
    local sg=Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_DECK,0,nil,e,tp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct
      or (ct>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
      or not aux.SelectUnselectGroup(sg,e,tp,ct,ct,rescon,0) then return end
    local ssg=aux.SelectUnselectGroup(sg,e,tp,ct,ct,rescon,1,tp,HINTMSG_SPSUMMON)
    if ssg:GetCount()==ct then
      for sc in aux.Next(ssg) do
        if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
          local e1=Effect.CreateEffect(c)
          e1:SetDescription(3206)
          e1:SetType(EFFECT_TYPE_SINGLE)
          e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
          e1:SetCode(EFFECT_CANNOT_ATTACK)
          e1:SetReset(RESET_EVENT+RESETS_STANDARD)
          sc:RegisterEffect(e1,true)
          sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,c:GetFieldID())
        end
      end
      if Duel.SpecialSummonComplete()>0 then
        ssg:KeepAlive()
        --Return them to the hand during the End Phase
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetCondition(s.condition1_2)
        e2:SetOperation(s.operation1_2)
        e2:SetLabel(c:GetFieldID())
        e2:SetLabelObject(ssg)
        e2:SetCountLimit(1)
        Duel.RegisterEffect(e2,tp)
        
        --Place Quest for the Masks in S/T zone
        if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tg:FilterCount(s.filter1c,nil,Duel.GetTurnCount())==ct 
          and Duel.IsExistingMatchingCard(s.filter1d,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
          Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
          local qg=Duel.SelectMatchingCard(tp,s.filter1d,tp,LOCATION_DECK,0,1,1,nil)
          if qg:GetCount()>0 then
            Duel.BreakEffect()
            Duel.MoveToField(qg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
          end
        end
      end
    end
  end
end
function s.filter1_2(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.condition1_2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.filter1_2,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.operation1_2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.filter1_2,nil,e:GetLabel())
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
