--Energized Protodermis Chamber
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetCondition(s.condition1)
  c:RegisterEffect(e1)
  --Fusion
  local params={nil,Fusion.CheckWithHandler(aux.FilterBoolFunction(Card.IsLocation,LOCATION_HAND)),nil,nil,Fusion.ForcedHandler,nil,2}
  local e2a=Effect.CreateEffect(c)
  e2a:SetDescription(aux.Stringid(id,0))
  e2a:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
  e2a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2a:SetProperty(EFFECT_FLAG_DELAY)
  e2a:SetCode(EVENT_SUMMON_SUCCESS)
  e2a:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
  e2a:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
  c:RegisterEffect(e2a)
  local e2b=e2a:Clone()
  e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2b)
  --To GY
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_TOGRAVE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetCode(EVENT_BE_MATERIAL)
  e3:SetCondition(s.condition3)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  c:RegisterEffect(e3)
end
function s.condition1(e,c)
  if c==nil then return true end
  return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
    and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
    and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
  return (r&REASON_FUSION)==REASON_FUSION and re:GetHandler()~=e:GetHandler()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsSummonType(SUMMON_TYPE_SPECIAL) end
  if chk==0 then return true end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectTarget(tp,Card.IsSummonType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,SUMMON_TYPE_SPECIAL)
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SendtoGrave(tc,REASON_EFFECT)
  end
end