--Gift of the Shrine
local s,id=GetID()
function c10100051.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
  if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)
end
function s.filter1a(c,tp)
  return c:IsFaceup() and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c)
end
function s.filter1b(c,ec)
	return c:IsSetCard(0xb04) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function s.filter1c(c,e,tp)
  return c:IsLevel(1) and c:IsRace(RACE_ROCK) and (c:GetAttack()==0 and c:IsDefenseBelow(0)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local tg=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,0,1,1,nil,tp)
  local eqg=Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,tg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eqg,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tc)
    if g:GetCount()>0 then
      if Duel.Equip(tp,g:GetFirst(),tc) and tc:IsSetCard(0xb02) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) 
        and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,s.filter1c,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
      end
    end
  end
end