--Circle of Legends, Amaja-Nui
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,nil,s.check0)
	c:EnableReviveLimit()
  --Multi-attribute
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(s.value1)
	c:RegisterEffect(e1)
	--To GY
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_TOGRAVE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
	--Special Summon Token
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,{id,1})
  c:RegisterEffect(e3)
end
s.listed_names={id+10000}
s.listed_series={0xb03}
function s.check0(g,lc)
  return g:IsExists(Card.IsSetCard,1,nil,0xb03)
end
function s.filter1(c)
  return c:IsType(TYPE_LINK) and c:IsSetCard(0xb03) and c:IsFaceup()
end
function s.value1(e,c)
  local att=0
  local tp=e:GetHandlerPlayer()
  local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  for tc in aux.Next(g) do
    att=att|tc:GetOriginalAttribute()
  end
  return att
end
function s.filter2(c)
  return c:IsSetCard(0xb03) and c:IsAbleToGrave()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoGrave(g,REASON_EFFECT)
  end
end
function s.filter3(c,tp)
	return c:IsRace(RACE_WARRIOR) and c:HasLevel() and c:IsAbleToDeck()
    and Duel.IsPlayerCanSpecialSummonMonster(tp,id+10000,0,TYPES_TOKEN,0,0,c:GetLevel(),RACE_WARRIOR,c:GetAttribute())
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local zone=e:GetHandler():GetLinkedZone(tp)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.filter3(chkc,tp) end
	if chk==0 then 
    return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 
      and Duel.IsExistingTarget(s.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) 
  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local zone=e:GetHandler():GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 then
		local token=Duel.CreateToken(tp,id+10000)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LEVEL)
    e1:SetValue(tc:GetLevel())
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
    token:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e2:SetValue(tc:GetAttribute())
    token:RegisterEffect(e2)
    
    if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP,zone)>0 then
      Duel.BreakEffect()
      
      if tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0 then
        Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
      else
        Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
      end
    end
	end
end