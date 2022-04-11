--Quest for the Masks
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
function s.filter1(c,ec)
	return (c:IsSetCard(0x1b04) or c:IsSetCard(0x2b04)) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
  return ec:IsSetCard(0xb02)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil,ec) end
	local eqg=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_DECK,0,nil,ec)
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,eqg,1,0,0)
  Duel.SetTargetCard(ec)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  local ec=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and ec:IsRelateToEffect(e) and ec:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil,ec)
    if g:GetCount()>0 then
      Duel.Equip(tp,g:GetFirst(),ec)
    end
  end
end
function s.filter2a(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xb04) and c:IsAbleToGrave()
end
function s.filter2b(c,e,tp,ct)
  return c:IsLevelBelow(ct) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,99,nil)
    if Duel.SendtoGrave(g1,REASON_EFFECT)>0 then
      local ct=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xb04):GetClassCount(Card.GetCode)
      if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_REMOVED,0,1,nil,e,tp,ct) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g2=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,ct)
        if Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)>0 then
          Duel.BreakEffect()
          Duel.Destroy(c,REASON_EFFECT)
        end
      end
    end
  end
end