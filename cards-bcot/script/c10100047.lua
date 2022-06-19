--Dimnished Matoran Nui
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot SS by other ways
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
  --To hand/grave
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCost(s.cost1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,{id,1})
	c:RegisterEffect(e2)
end
s.listed_series={0xb01}
function s.filter1a(c)
  return c:IsLevel(2) and c:IsSetCard(0xb01)
end
function s.filter1b(c)
  return s.filter1a(c) and c:IsAbleToHand()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetAttribute)>=3 end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetAttribute)>=3 then
		local cg=Group.CreateGroup()
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			g:Remove(Card.IsAttribute,nil,sg:GetFirst():GetAttribute())
			cg:Merge(sg)
		end
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=cg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
    if tc:IsAbleToHand() then
      Duel.SendtoHand(tc,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,tc)
      cg:RemoveCard(tc)
    end
		Duel.SendtoGrave(cg,REASON_EFFECT)
	end
end
function s.filter2(c)
	return c:IsSetCard(0xb01) and c:IsLevel(2) and c:IsAbleToDeckOrExtraAsCost()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=6 end
  local sg=aux.SelectUnselectGroup(g,e,tp,6,6,aux.dncheck,1,tp,HINTMSG_TODECK)
  Duel.SendtoDeck(sg,tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
  if chk==0 then 
      return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true)
        and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) 
  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_GRAVE)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
      Duel.Destroy(tc,REASON_EFFECT)
    end
  end
end