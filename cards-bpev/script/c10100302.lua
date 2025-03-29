--Energized Protodermis Destiny
local s,id=GetID()
function s.initial_effect(c)
  --Special or Fusion Summon
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_FUSION_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
  c:RegisterEffect(e1)
end
s.listed_names={id+10000}
s.listed_series={0xb0b}
function s.filter1(c,e,tp)
  return c:IsSetCard(0xb0b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
  if chk==0 then return
    Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
      and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
      and Duel.IsPlayerCanSpecialSummonMonster(tp,id+10000,0,0,TYPES_TOKEN,0,1,RACE_AQUA,ATTRIBUTE_LIGHT)
  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local tg=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)

  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
  Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,tg,1,0,0)
  Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0)
  Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
  Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local token=Duel.CreateToken(tp,id+10000)
  local tc=Duel.GetFirstTarget()
  local mg=Group.FromCards(tc,token)
  local params={fusfilter=aux.FilterBoolFunction(Card.ListsArchetypeAsMaterial,0xb0b),
    matfilter=Fusion.OnFieldMat(function(c) return mg:IsContains(c) end),sumpos=POS_FACEUP_DEFENSE,exactcount=2}

  if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsRelateToEffect(e) then
    local b1=tc:IsAbleToGrave()
    local b2=Fusion.SummonEffTG(params)(e,tp,eg,ep,ev,re,r,rp,0)
    local sel=Duel.SelectEffect(tp,
      {b1,aux.Stringid(id,0)},
      {b2,aux.Stringid(id,1)})

    if sel==1 then
      Duel.BreakEffect()
      if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp,token)>0
        and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil,e,tp)
        and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        if Duel.Destroy(token,REASON_EFFECT)>0 then
          local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
          if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
          end
        end
      end
    elseif sel==2 then
      Duel.BreakEffect()
      Fusion.SummonEffOP(params)(e,tp,eg,ep,ev,re,r,rp)
    end
  end
end
