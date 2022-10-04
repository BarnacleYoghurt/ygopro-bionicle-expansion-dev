--Energized Protodermis Destiny
local s,id=GetID()
function s.initial_effect(c)
  --Special or Fusion Summon
  --TODO: We have to conduct a fusion summon here with a monster that isn't in any location until the effect resolves. This is a pain in the ass.
	local params={nil,aux.FilterBoolFunction(Card.IsLocation,LOCATION_MZONE),s.extrafil1,nil,nil,nil,2}
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_FUSION_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  c:RegisterEffect(e1)
end
function s.extrafil1(e,tp,mg)
  return Group.FromCards(Duel.CreateToken(tp,id+10000))
end
function s.filter1a(c,e,tp)
  return c:IsFaceup() and (
    Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK,0,1,nil,e,tp) or
    (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+10000,0,0,TYPES_TOKEN,0,1,RACE_AQUA,ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_EXTRA,0,1,nil,e,tp))
  )
end
function s.filter1b(c,e,tp)
  return c:IsSetCard(0xb0b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter1c(c,e,tp)
  return true
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1a(chkc,e,tp) end
  if chk==0 then return Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local tg=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  local tc=tg:GetFirst()
  local b1=(Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK,0,1,nil,e,tp))
  local b2=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
    and Duel.IsPlayerCanSpecialSummonMonster(tp,id+10000,0,0,TYPES_TOKEN,0,1,RACE_AQUA,ATTRIBUTE_LIGHT) 
    and Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_EXTRA,0,1,nil,e,tp))
  
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
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
  elseif sel==1 then
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
  end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) then return end
  
  if e:GetLabel()==0 then
    if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
      local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_DECK,0,1,1,nil,e,tp)
      if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
      end
    end
  elseif e:GetLabel()==1 then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
      local token=Duel.CreateToken(tp,id+10000)
      if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.BreakEffect()
        --Hack to just try and fusion summon without any checks
        local gc=Group.FromCards(tc,token)
        local params={nil,Fusion.OnFieldMat(function(c) return gc:IsContains(c) end),nil,nil,nil,nil,2}
        Fusion.SummonEffOP(table.unpack(params))(e,tp,eg,ep,ev,re,r,rp)
      end
    end
    Debug.Message("this one is hard") 
  end
end
  
