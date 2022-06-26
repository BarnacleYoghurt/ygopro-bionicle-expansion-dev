--Suva
local s,id=GetID()
function s.initial_effect(c)
	--Multi-attribute
  local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE)
	e1a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1a:SetRange(LOCATION_HAND)
	e1a:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1a:SetValue(ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND)
	c:RegisterEffect(e1a)
  local e1b=e1a:Clone()
  e1b:SetRange(LOCATION_MZONE)
  e1b:SetCondition(s.condition1)
  c:RegisterEffect(e1b)
  --Swap Kanohi
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetCondition(s.condition3)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
s.listed_series={0xb05,0xb02,0xb04}
function s.filter1(c)
  return c:IsFaceup() and c:IsSetCard(0xb05)
end
function s.condition1(e)
  local tp=e:GetHandlerPlayer()
  return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_FZONE,0,1,nil)
end
function s.filter2a(c,tp)
  return c:IsFaceup() and c:IsSetCard(0xb02) and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,c)
end
function s.filter2b(c,ec)
  return not c:IsForbidden() and c:IsSetCard(0xb04) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec) 
    and not (c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:GetTurnID()==Duel.GetTurnCount())
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,600) end
  Duel.PayLPCost(tp,600)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter2a(chkc,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(s.filter2a,tp,LOCATION_MZONE,0,1,nil,tp) and c:GetFlagEffect(id)==0 end
  c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
  local tg=Duel.SelectTarget(tp,s.filter2a,tp,LOCATION_MZONE,0,1,1,nil,tp)
  local eqg=Duel.GetMatchingGroup(s.filter2b,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,tg:GetFirst())
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,eqg,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2b),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tc)
    if g:GetCount()>0 then
      Duel.Equip(tp,g:GetFirst(),tc)
    end
  end
end
function s.filter3(c)
  return c:IsFaceup() and c:IsSetCard(0xb02)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,nil)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_GRAVE)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end