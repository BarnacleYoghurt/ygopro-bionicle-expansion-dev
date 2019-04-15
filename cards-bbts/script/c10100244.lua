--Turaga of The Swarm
function c10100244.initial_effect(c)
  --synchro summon
  local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
  e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10100244.cost1)
	e1:SetTarget(c10100244.target1)
	e1:SetOperation(c10100244.operation1)
  e1:SetCountLimit(1)
	c:RegisterEffect(e1)
  --take control
  local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c10100244.condition2)
	e2:SetTarget(c10100244.target2)
	e2:SetOperation(c10100244.operation2)
	c:RegisterEffect(e2)
end
function c10100244.filter1a(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15d) and c:IsAbleToGraveAsCost()
end
function c10100244.filter1b(c)
  return c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsAbleToRemove()
end
function c10100244.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100244.filter1a,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c10100244.filter1a,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function c10100244.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100244.filter1b,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SelectTarget(tp,c10100244.filter1b,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10100244.operation1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then 
    if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) and c:IsRelateToEffect(e) then
      Duel.BreakEffect()
      Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
      Duel.BreakEffect()
      local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,1-tp,LOCATION_EXTRA,0,nil,c)
      if g:GetCount()>0 then
        local sg=g:Select(1-tp,1,1,nil)
        Duel.SynchroSummon(1-tp,sg:GetFirst(),c)
      end
    end
  end
end
function c10100244.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c10100244.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
  if chk==0 then return rc:IsAbleToChangeControler() end
end
function c10100244.operation2(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
  Duel.GetControl(rc,tp)
end