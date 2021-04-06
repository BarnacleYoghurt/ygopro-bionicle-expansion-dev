if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Toa Mata Pohatu
local s,id=GetID()
function s.initial_effect(c)
	 --Tribute from hand
  local e1=bcot.toa_mata_tribute(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
	--S/T Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function s.filter2a(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.filter2b(c)
	return c:IsFaceup() and c:IsRace(RACE_ROCK)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter2a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filter2a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
    if Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
      local g=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
      if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
      end
    end
	end
end