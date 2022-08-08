--Krana Ja-Kal, Tracker
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,s.filter0,1,1)
	c:EnableReviveLimit()
  --No Link Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(s.cost2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
  --Scout
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_REMOVE)
  e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
  e3:SetCondition(s.condition3)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1)
  c:RegisterEffect(e3)
end
function s.filter0(c)
  return c:IsSetCard(0xb08) or c:IsSetCard(0xb09)
end
function s.filter2(c,e,tp)
  return c:IsLevel(4) and c:IsSetCard(0xb08) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsReleasable() end
  Duel.Release(c,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then 
    return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) 
  end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
    --Return it to deck if it leaves the field
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(3301)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
    e1:SetValue(LOCATION_DECKSHF)
    g:GetFirst():RegisterEffect(e1,true)
  end
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSetCard(0xb08)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanRemove(tp) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local rg=Duel.GetDecktopGroup(1-tp,1)
  if #rg>0 then
    local rc=rg:GetFirst()
    if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_REMOVED) then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD)
      e1:SetTargetRange(0,LOCATION_ALL)
      e1:SetCode(EFFECT_DISABLE)
      e1:SetTarget(s.target3_1)
      e1:SetLabel(rc:GetCode())
      e1:SetReset(RESET_PHASE+PHASE_END,2)
      Duel.RegisterEffect(e1,tp)
    end
  end
end
function s.target3_1(e,c)
	return c:IsCode(e:GetLabel())
end