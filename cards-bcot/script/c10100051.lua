--Gift of the Shrine
local s,id=GetID()
function s.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
end
s.listed_series={0xb04,0x2b04,0x1b04}
function s.filter1a(c,tp)
  return c:IsFaceup() and (
    Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c) or
    (Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.filter1d,tp,LOCATION_DECK,0,1,nil,c))
  )
end
function s.filter1b(c,ec)
	return not c:IsForbidden() and c:IsSetCard(0xb04) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function s.filter1c(c)
  return c:IsLevel(1) and c:IsRace(RACE_ROCK) and (c:GetAttack()==0 and c:IsDefenseBelow(0)) and c:IsAbleToRemove()
end
function s.filter1d(c,ec)
	return not c:IsForbidden() and (c:IsSetCard(0x1b04) or c:IsSetCard(0x2b04)) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1a(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local tg=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,0,1,1,nil,tp)
  local tc=tg:GetFirst()
  local b1=(Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tc))
  local b2=(Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) 
    and Duel.IsExistingMatchingCard(s.filter1d,tp,LOCATION_DECK,0,1,nil,tc))
  
  local sel=-1
  if b1 and b2 then
    sel=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
  elseif b1 then
    sel=Duel.SelectOption(tp,aux.Stringid(id,0))
  elseif b2 then
    sel=Duel.SelectOption(tp,aux.Stringid(id,1))+1
  end
  e:SetLabel(sel)
  
  if sel==0 then
    local eqg=Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,tc)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,eqg,1,0,0)
  elseif sel==1 then
    local eqg=Duel.GetMatchingGroup(s.filter1d,tp,LOCATION_DECK,0,nil,tc)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,eqg,1,0,0)
  end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
  
  local sg=Group.CreateGroup()
  if e:GetLabel()==0 then
    sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter1b),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tc)
  elseif e:GetLabel()==1 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rg=Duel.SelectMatchingCard(tp,s.filter1c,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
    if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then
      sg=Duel.GetMatchingGroup(s.filter1d,tp,LOCATION_DECK,0,nil,tc)
    end
  end
      
  if sg:GetCount()>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=sg:Select(tp,1,1,nil)
    if g:GetCount()>0 then
      Duel.Equip(tp,g:GetFirst(),tc)
    end
  end
end