--Ga-Koro, Village of Water
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --Response block
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetRange(LOCATION_FZONE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCondition(s.condition1)
  e1:SetOperation(s.operation1)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
s.listed_attributes={ATTRIBUTE_WATER}
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
  return Duel.GetTurnPlayer()~=tp and g:GetCount()>0 and g:GetCount()==g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and Duel.GetCurrentChain()>1 and rp==tp then
		Duel.SetChainLimit(s.limit1_1)
	end
end
function s.limit1_1(e,rp,tp)
	return tp==rp
end
function s.filter2a(c)
  return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.filter2b(c,e,tp)
  return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_GRAVE,0,1,1,nil)
  e:SetLabel(g:GetFirst():GetRace())
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then 
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e0:SetRange(LOCATION_FZONE)
    e0:SetTargetRange(1,0)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetTarget(s.target2_1)
    e0:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e0,tp)
    aux.RegisterClientHint(c,nil,tp,1,0,aux.Stringid(id,1),nil)
    
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_HAND,0,1,1,nil,e,tp)
      if g:GetCount()>0 then
        local tc=g:GetFirst()
        if Duel.SpecialSummonStep(tc,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP_DEFENSE) then
          local e1=Effect.CreateEffect(c)
          e1:SetType(EFFECT_TYPE_SINGLE)
          e1:SetCode(EFFECT_DISABLE)
          e1:SetReset(RESET_EVENT+RESETS_STANDARD)
          tc:RegisterEffect(e1,true)
          local e2=Effect.CreateEffect(c)
          e2:SetType(EFFECT_TYPE_SINGLE)
          e2:SetCode(EFFECT_DISABLE_EFFECT)
          e2:SetReset(RESET_EVENT+RESETS_STANDARD)
          tc:RegisterEffect(e2,true)
          local e3=Effect.CreateEffect(c)
          e3:SetType(EFFECT_TYPE_SINGLE)
          e3:SetCode(EFFECT_CHANGE_RACE)
          e3:SetValue(e:GetLabel())
          e3:SetReset(RESET_EVENT+RESETS_STANDARD)
          tc:RegisterEffect(e3,true)
        end
        Duel.SpecialSummonComplete()
      end
    end
  end
end
function s.target2_1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsAttribute(ATTRIBUTE_WATER))
end