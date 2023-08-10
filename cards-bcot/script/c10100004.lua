if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Toa Mata Pohatu
local s,id=GetID()
function s.initial_effect(c)
	 --Tribute from hand
  local e1=bcot.toa_mata_tribute(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
	--S/T Destroy
	local e2a=Effect.CreateEffect(c)
	e2a:SetDescription(aux.Stringid(id,1))
	e2a:SetCategory(CATEGORY_DESTROY)
	e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2a:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2a:SetCondition(s.condition2a)
	e2a:SetTarget(s.target2)
	e2a:SetOperation(s.operation2)
  e2a:SetCountLimit(1)
	c:RegisterEffect(e2a)
  local e2b=e2a:Clone()
  e2b:SetCode(EVENT_CHAINING)
  e2b:SetCondition(s.condition2b)
  c:RegisterEffect(e2b)
end
s.listed_series={0x1b02}
function s.filter2a(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.filter2b(c)
	return c:IsFaceup() and c:IsRace(RACE_ROCK)
end
function s.condition2a(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_EXTRA)
end
function s.condition2b(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSummonLocation(LOCATION_EXTRA) 
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.filter2a(chkc) end
	if chk==0 then 
    return e:GetHandler():GetFlagEffect(id)==0 --check in target so triggers chained to first activation don't sneak through
      and Duel.IsExistingTarget(s.filter2a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filter2a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  --Shared OPT for both triggers
  e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
    if Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tc) and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
      local g=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tc)
      if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
      end
    end
	end
end