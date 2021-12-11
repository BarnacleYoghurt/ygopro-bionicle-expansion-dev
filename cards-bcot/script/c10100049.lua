if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Great Kanohi Rua
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
  e2:SetCondition(s.condition)
  e2:SetValue(s.value2)
	c:RegisterEffect(e2)
	--Hand Reveal
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_HAND)
  e3:SetCondition(s.condition)
	c:RegisterEffect(e3)
	--Xyz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.condition4)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation4)
	c:RegisterEffect(e4)
end
function s.condition(e)
  return bcot.kanohi_con(e,{0x2b02})
end
function s.value2(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function s.filter4a(c,e,tp,lv)
	return c:IsSetCard(0x1b02) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false) 
    and Duel.IsExistingMatchingCard(s.filter4b,tp,LOCATION_EXTRA,0,1,nil,tp,Group.FromCards(c))
end
function s.filter4b(c,tp,sg)
  local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return c:IsSetCard(0xb02) and c:IsXyzSummonable(sg:GetFirst(),Group.Merge(g,sg)) and Duel.GetLocationCountFromEx(tp,tp,Group.Merge(g,sg),c)>0
end
function s.condition4(e,tp,eg,ep,ev,re,r,rp)
  return bcot.kanohi_con(e,{0x1b02}) and e:GetHandler():GetEquipTarget():IsControler(tp)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ec and ec:HasLevel()
      and Duel.IsExistingMatchingCard(s.filter4a,tp,LOCATION_HAND,0,1,nil,e,tp,ec:GetLevel())
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
  local ec=e:GetHandler():GetEquipTarget()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not (ec and ec:HasLevel() and e:GetHandler():IsRelateToEffect(e)) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,s.filter4a,tp,LOCATION_HAND,0,1,1,nil,e,tp,ec:GetLevel())
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
    Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyzg=Duel.SelectMatchingCard(tp,s.filter4b,tp,LOCATION_EXTRA,0,1,1,nil,tp,g)
		if xyzg:GetCount()>0 then
			Duel.XyzSummon(tp,xyzg:GetFirst(),g:GetFirst())
		end
  end
end