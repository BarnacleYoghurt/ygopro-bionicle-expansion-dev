--Waikiru, Walrus Rahi
function c10100237.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(10100237,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10100237.condition1)
	e1:SetTarget(c10100237.target1)
	e1:SetOperation(c10100237.operation1)
	c:RegisterEffect(e1)
	--Buffs
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100237,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCondition(c10100237.condition2)
	e2:SetOperation(c10100237.operation2)
	e2:SetCountLimit(1,10100237)
	c:RegisterEffect(e2)
	--Change BP
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c10100237.condition3)
	e3:SetOperation(c10100237.operation3)
	c:RegisterEffect(e3)
end
function c10100237.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c10100237.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_SZONE)
end
function c10100237.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100237.filter2(c,tp)
  return c:IsFaceup() and c:IsControler(tp)
end
function c10100237.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10100237.filter2,1,nil,tp)
end
function c10100237.operation2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  local g=eg:Filter(c10100237.filter2,nil,tp)
	if g:GetCount()>0 then
    local tc=g:GetFirst()
    while tc do
      if tc:IsPosition(POS_FACEUP_DEFENSE) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        e1a=e1:Clone()
        e1a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        tc:RegisterEffect(e1a)
      else
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        if tc:IsType(TYPE_XYZ) then
          e2:SetValue(200*tc:GetRank())
        else
          e2:SetValue(200*tc:GetLevel())
        end
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
      end
      tc=g:GetNext()
    end
  end
end
function c10100237.condition3(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c10100237.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetDescription(aux.Stringid(10100237,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10100237.target3_1)
	e1:SetOperation(c10100237.operation3_1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
  if not c:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2,true)
	end
end
function c10100237.filter3_1(c,pos)
  return c:IsFaceup() and c:IsPosition(pos)
end
function c10100237.target3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c10100237.operation3_1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
  local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
  if g:GetCount()>0 then
    local tc=g:GetFirst()
    if Duel.IsExistingMatchingCard(c10100237.filter3_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc,tc:GetPosition()) and Duel.SelectYesNo(tp,aux.Stringid(10100237,3)) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
      g2 = Duel.SelectMatchingCard(tp,c10100237.filter3_1,tp,LOCATION_MZONE,LOCATION_MZONE,0,1,tc,tc:GetPosition())
      g:Merge(g2)
    end
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
  end
end
