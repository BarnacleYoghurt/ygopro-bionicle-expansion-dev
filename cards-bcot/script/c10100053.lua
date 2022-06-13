--Call of the Toa Stones
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end
s.roll_dice=true
s.listed_series={0x1b02}
s.listed_names={10100015}
function s.filter1a(c)
  return c:IsSetCard(0x1b02) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.filter1b(c)
  return c:IsCode(10100015) and c:IsSSetable()
end
function s.filter1c(c)
  return c:IsLevel(1) and c:IsRace(RACE_ROCK) and (c:GetAttack()==0 and c:IsDefenseBelow(0)) and c:IsAbleToHand()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,LOCATION_DECK,tp,1)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
    local dc=Duel.TossDice(tp,1)
    Duel.ConfirmDecktop(tp,dc)
    local dg=Duel.GetDecktopGroup(tp,dc)
    local fg=dg:Filter(s.filter1a,nil)
    local ac=0
    if fg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
      local sg=aux.SelectUnselectGroup(fg,e,tp,1,2,aux.dncheck,1,tp,HINTMSG_ATOHAND)
      ac=Duel.SendtoHand(sg,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,sg)
    end
    Duel.ShuffleDeck(tp)
    
    if ac==0 then
      if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK,0,1,nil) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
          Duel.BreakEffect()
          Duel.SSet(tp,g)
          local e1=Effect.CreateEffect(e:GetHandler())
          e1:SetType(EFFECT_TYPE_SINGLE)
          e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
          e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
          e1:SetReset(RESET_EVENT+RESETS_STANDARD)
          g:GetFirst():RegisterEffect(e1)
        end
      end
    elseif ac==1 then
      if Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_DECK,0,1,nil) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.filter1c,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
          Duel.BreakEffect()
          Duel.SendtoHand(g,tp,REASON_EFFECT)
          Duel.ConfirmCards(1-tp,g)
        end
      end
    elseif ac==2 then
      Duel.BreakEffect()
      Duel.Recover(tp,1800,REASON_EFFECT)
    end
  end
end
