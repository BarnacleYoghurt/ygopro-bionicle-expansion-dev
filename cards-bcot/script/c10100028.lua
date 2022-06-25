--Po-Koro, Village of Stone
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(s.target1)
	e1:SetValue(s.value1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--Summon Token
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
  --Material check (to also recognize materials that are only EARTH on the field (e.g. Suva))
  local mcheck=Effect.CreateEffect(c)
	mcheck:SetType(EFFECT_TYPE_FIELD)
	mcheck:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	mcheck:SetRange(LOCATION_FZONE)
	mcheck:SetCode(EFFECT_MATERIAL_CHECK)
	mcheck:SetValue(s.value_mcheck)
	c:RegisterEffect(mcheck)
end
s.listed_names={id+10000}
s.listed_attributes={ATTRIBUTE_EARTH}
function s.value_mcheck(e,c)
  local ct=c:GetMaterial():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)
	if ct>0 then
		c:RegisterFlagEffect(id,RESET_EVENT+((RESETS_STANDARD|RESET_OVERLAY)&~RESET_TOFIELD)+RESET_PHASE+PHASE_END,0,1,ct)
	end
end

function s.filter1a(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and not c:IsReason(REASON_REPLACE)
end
function s.filter1b(c)
  return c:IsFaceup() and c:IsRace(RACE_ROCK) and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(s.filter1a,1,nil,tp) and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_MZONE,0,1,nil) end
  if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local g=eg:Filter(s.filter1a,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		return true
	else 
    return false 
  end
end
function s.value1(e,c)
	return c==e:GetLabelObject()
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetLabelObject() --STATUS_BATTLE_DESTROYED is already gone here, so need to explicitly prevent self-trade
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_MZONE,0,1,1,c)
  if g:GetCount()>0 then
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
  end
end
function s.filter2(c)
  return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR) and c:IsAbleToRemoveAsCost()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  if eg:GetCount()~=1 then return false end
  local ec=eg:GetFirst()
  return ec:GetSummonPlayer()==tp and ec:GetFlagEffect(id)~=0
    and (ec:GetSummonType()&(SUMMON_TYPE_FUSION|SUMMON_TYPE_SYNCHRO|SUMMON_TYPE_XYZ|SUMMON_TYPE_LINK))>0
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=eg:GetFirst():GetFlagEffectLabel(id)
  if chk==0 then 
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct 
      and Duel.IsPlayerCanSpecialSummonMonster(tp,id+10000,0,0,TYPES_TOKEN,0,1,RACE_ROCK,ATTRIBUTE_EARTH)
      and not (ct>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
  end
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,0)
  e:SetLabel(ct)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  
  local st=eg:GetFirst():GetSummonType()&(SUMMON_TYPE_FUSION|SUMMON_TYPE_SYNCHRO|SUMMON_TYPE_XYZ|SUMMON_TYPE_LINK)
  local desc={
    [SUMMON_TYPE_FUSION]  = 2,
    [SUMMON_TYPE_SYNCHRO] = 3,
    [SUMMON_TYPE_XYZ]     = 4,
    [SUMMON_TYPE_LINK]    = 5
  } --Lookup table for client hints depending on summon type
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(s.target2_1)
  e1:SetLabel(st)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
  aux.RegisterClientHint(c,nil,tp,1,0,aux.Stringid(id,desc[st]),nil)
  
  local ct=e:GetLabel()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct and Duel.IsPlayerCanSpecialSummonMonster(tp,id+10000,0,0,TYPES_TOKEN,0,1,RACE_ROCK,ATTRIBUTE_EARTH) 
    and not (ct>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then
    for i=1,ct do
      local token=Duel.CreateToken(tp,id+10000)
      Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
    end
    Duel.SpecialSummonComplete()
  end
end
function s.target2_1(e,c,sump,sumtype,sumpos,targetp,se)
	return (sumtype&e:GetLabel())==e:GetLabel()
end