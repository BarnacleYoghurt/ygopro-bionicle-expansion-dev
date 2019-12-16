if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Nuhvok
function c10100203.initial_effect(c)
	--flip
  local e1=bbts.bohrok_flip(c)
  c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
  e2:SetDescription(aux.Stringid(10100203,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10100203.target2)
	e2:SetOperation(c10100203.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function c10100203.filter2(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c10100203.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10100203.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local tg=Duel.SelectTarget(tp,c10100203.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c10100203.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) and tc:IsPreviousLocation(LOCATION_SZONE) and seq<5 then
    local of = tc:GetControler()-tp
    if of<0 then of = -of end --0 if own card, 1 if opponent's
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetOperation(c10100203.operation2_1)
		e1:SetLabel(seq+8+of*16)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		Duel.RegisterEffect(e1,tp)
	end
  --To Deck
  local e1=bbts.bohrok_shuffledelayed(c)
  Duel.RegisterEffect(e1,tp)
end
function c10100203.operation2_1(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end