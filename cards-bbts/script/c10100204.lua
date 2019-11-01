if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Pahrak
function c10100204.initial_effect(c)
	--flip
  local e1=bbts.bohrok_flip(c)
  c:RegisterEffect(e1)
	--Block effects during battle
	local e2=Effect.CreateEffect(c)
  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	e2:SetCondition(c10100204.condition2)
	c:RegisterEffect(e2)
  local e2a=e2:Clone()
	e2a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  c:RegisterEffect(e2a)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_TARGET)
	e3:SetCondition(c10100204.condition3)
	e3:SetTarget(c10100204.target3)
	e3:SetOperation(c10100204.operation3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
function c10100204.filter1(c,e,tp)
	return c:IsSetCard(0x15c) and c:GetLevel()==4 and not c:IsCode(10100204) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100204.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10100204.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c10100204.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10100204.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c10100204.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10100204.value2a(e,re,rp)
	return re:GetHandlerPlayer()~=e:GetHandler()
end
function c10100204.condition2(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c10100204.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c10100204.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local tg=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c10100204.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.Destroy(tc,REASON_EFFECT)
	end
  --To deck
  local e1=bbts.bohrok_shuffledelayed(e:GetHandler())
  Duel.RegisterEffect(e1, tp)
end
