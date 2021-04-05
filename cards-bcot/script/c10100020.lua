--Turaga Onewa
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(aux.zptcon(s.filter1a))
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
end
function s.filter0(c)
  return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function s.check0(g,lc)
  return g:IsExists(s.filter0,1,nil)
end
function s.filter1a(c)
  return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.filter1b(c,e,tp)
  return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.filter1b,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local tg=Duel.SelectTarget(tp,s.filter1b,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsRelateToEffect(e) then
    if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
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
      e3:SetDescription(3300)
      e3:SetType(EFFECT_TYPE_SINGLE)
      e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
      e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
      e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
      e3:SetValue(LOCATION_REMOVED)
      tc:RegisterEffect(e3,true)
    end
    Duel.SpecialSummonComplete()
  end
end