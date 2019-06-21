--Exo-Toa
function c10100250.initial_effect(c)
  --equip
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c10100250.target1)
	e1:SetOperation(c10100250.operation1)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10100250.target2)
	e2:SetOperation(c10100250.operation2)
	c:RegisterEffect(e2)
	--destroy sub
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e3:SetValue(c10100250.value3)
	c:RegisterEffect(e3)
  --Special Summon
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_SPSUMMON_PROC)
  e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e4:SetCondition(c10100250.condition4)
  e4:SetValue(1)
  c:RegisterEffect(e4)
  --Negate effects
  local e5=Effect.CreateEffect(c)
  --Override name
  local e6=Effect.CreateEffect(c)
  --Boost
  local e7=Effect.CreateEffect(c)
	--eqlimit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_EQUIP_LIMIT)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetValue(c10100250.value8)
	c:RegisterEffect(e8)
end
function c10100250.filter1(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsSetCard(0x155) and ct2==0
end
function c10100250.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
    return e:GetHandler():GetFlagEffect(10100250)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c10100250.filter1,tp,LOCATION_MZONE,0,1,c)
  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c10100250.filter1,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(10100250,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100250.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c10100250.filter1(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if Duel.Equip(tp,c,tc,false) then
    aux.SetUnionState(c)
  end
end
function c10100250.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
    return c:GetFlagEffect(10100250)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(10100250,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100250.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c10100250.value3(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function c10100250.filter4(c)
  return c:IsFaceup() and c:IsSetCard(0x155) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function c10100250.condition4(e,c)
  if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10100250.filter4,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c10100250.value8(e,c)
	return (c:IsSetCard(0x155)) or e:GetHandler():GetEquipTarget()==c
end