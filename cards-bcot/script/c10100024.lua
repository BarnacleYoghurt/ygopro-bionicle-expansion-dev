--The Great Temple,Kini-Nui
local s,id=GetID()
function c10100024.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Extra NS
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1b02))
	c:RegisterEffect(e1)
  --Recycle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,2))
  e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCode(EVENT_PHASE+PHASE_END)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,{id,1})
  c:RegisterEffect(e3)
end
s.listed_series={0x1b02,0xb02}
function s.filter2(c,e,tp,r)
  return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) 
    and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0x1b02) and c:IsSetCard(0xb02)
    and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local pg=eg:Filter(s.filter2,nil,e,tp,r)
  if chkc then return pg:IsContains(chkc) end
  if chk==0 then return pg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local tg=pg:Select(tp,1,1,nil)
  Duel.SetTargetCard(tg)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)  
  local tc=Duel.GetFirstTarget()
  if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(3300)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e1:SetValue(LOCATION_REMOVED)
    e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
    tc:RegisterEffect(e1,true)
    Duel.SpecialSummonComplete()
  end
end
function s.filter3(c,e,tp)
  return c:GetLevel()==1 and c:IsRace(RACE_ROCK) and (c:GetAttack()==0 and c:IsDefenseBelow(0)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)  
  if e:GetHandler():IsRelateToEffect(e) then
    if Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
      if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
      end
    end
  end
end