--Toa Seal
function c10100254.initial_effect(c)
  --Seal
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(10100254,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c10100254.target1)
  e1:SetOperation(c10100254.operation1)
  e1:SetCountLimit(1,10100254)
  c:RegisterEffect(e1)
end
function c10100254.filter1(c,e)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x155) and c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function c10100254.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.GetMatchingGroup(c10100254.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil,e):GetClassCount(Card.GetCode)>=6 
      and Duel.IsExistingMatchingCard(c10100254.filter1,tp,LOCATION_MZONE,0,2,nil,e)
      and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
  end
  local g1=Duel.GetMatchingGroup(c10100254.filter1,tp,LOCATION_MZONE,0,nil,e)
  local g2=Duel.GetMatchingGroup(c10100254.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil,e)
  local tg=Group.CreateGroup()
	for i=1,6 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tgi
    if i<=2 then
      tgi=g1:Select(tp,1,1,nil)
    else
      tgi=g2:Select(tp,1,1,nil)
    end
		g1:Remove(Card.IsCode,nil,tgi:GetFirst():GetCode())
		g2:Remove(Card.IsCode,nil,tgi:GetFirst():GetCode())
		tg:Merge(tgi)
	end
  Duel.SetTargetCard(tg)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,tg:GetCount(),0,0)
  
  local g0=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g0,g0:GetCount(),0,0)
  if tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
  end
  if tg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
    local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,g2:GetCount(),0,0)
  end
end
function c10100254.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g0=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
  if Duel.Remove(g0,POS_FACEUP,REASON_EFFECT) then
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE+LOCATION_HAND) then
      Duel.BreakEffect()
      if tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
        local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
        if Duel.Remove(tg1,POS_FACEUP,REASON_EFFECT) then
          local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
          Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
        end
      end
      if tg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
        local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
        if Duel.Remove(tg2,POS_FACEUP,REASON_EFFECT) then
          local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
          Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
        end
      end
    end
  end
end
      
      

