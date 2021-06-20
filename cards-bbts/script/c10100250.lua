--Exo-Toa
local s,id=GetID()
function s.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xb02))
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetCondition(s.condition1)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --Negate effects
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCode(EFFECT_DISABLE)
  c:RegisterEffect(e2)
  --Override name
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_EQUIP)
  e3:SetCode(EFFECT_CHANGE_CODE)
  e3:SetValue(id)
  c:RegisterEffect(e3)
  --Boost
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_EQUIP)
  e4:SetCode(EFFECT_UPDATE_ATTACK)
  e4:SetValue(2000)
  c:RegisterEffect(e4)
  --Search
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(id,2))
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetRange(LOCATION_GRAVE)
  e5:SetCode(EVENT_PHASE+PHASE_END)
  e5:SetCondition(s.condition5)
  e5:SetTarget(s.target5)
  e5:SetOperation(s.operation5)
  e5:SetCountLimit(1,id)
  c:RegisterEffect(e5)
end
function s.filter1(c)
  return c:IsFaceup() and c:IsSetCard(0xb02) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function s.condition1(e,c)
  if c==nil then return true end
  local mc=Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and mc>0 and Duel.IsExistingMatchingCard(s.filter1,c:GetControler(),LOCATION_MZONE,0,mc,nil)
end
function s.filter5(c)
  return c:IsCode(10100251) and c:IsSSetable()
end
function s.condition5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()==Duel.GetTurnCount()
end
function s.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter5,tp,LOCATION_DECK,0,1,nil) end
end
function s.operation5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(s.filter5,tp,LOCATION_DECK,0,nil)
  if tc then
    Duel.SSet(tp,tc)
    Duel.ConfirmCards(1-tp,tc)
  end
end