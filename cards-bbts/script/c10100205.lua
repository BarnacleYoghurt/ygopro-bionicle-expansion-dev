if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Kohrak
function c10100205.initial_effect(c)
	--flip
  local e1=bbts.bohrok_flip(c)
  c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
  e2:SetDescription(aux.Stringid(10100205,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10100205.condition2)
	e2:SetCost(c10100205.cost2)
	e2:SetTarget(c10100205.target2)
	e2:SetOperation(c10100205.operation2)
	c:RegisterEffect(e2)
end
function c10100205.filter2(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c10100205.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackAnnouncedCount()==0
end
function c10100205.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c10100205.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100205.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10100205.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
end
function c10100205.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c10100205.filter2(tc) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
