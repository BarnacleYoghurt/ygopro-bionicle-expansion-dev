if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Bohrok Pahrak
function s.initial_effect(c)
	--flip
  local e1=bbts.bohrok_flip(c)
  c:RegisterEffect(e1)
	--Protection during battle
	local e2=Effect.CreateEffect(c)
  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	e2:SetCondition(s.condition2)
	c:RegisterEffect(e2)
  local e2a=e2:Clone()
	e2a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  c:RegisterEffect(e2a)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
  e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
function s.condition2(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.Destroy(tc,REASON_EFFECT)
	end
  --To deck
  local e1=bbts.bohrok_shuffledelayed(e:GetHandler())
  Duel.RegisterEffect(e1, tp)
end
