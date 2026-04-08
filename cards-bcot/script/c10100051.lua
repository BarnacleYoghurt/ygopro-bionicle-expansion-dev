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
    Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_HAND|LOCATION_GRAVE,0,1,nil,c) or
    (Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_MZONE|LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_DECK|LOCATION_REMOVED,0,1,nil,c))
  )
end
function s.filter1b(c,ec)
    return not c:IsForbidden() and c:IsSetCard(0xb04) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function s.filter1c(c)
    return c:IsLevel(1) and c:IsRace(RACE_ROCK) and (c:GetAttack()==0 and c:IsDefenseBelow(0))
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1a(chkc,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local tg=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,0,1,1,nil,tp)
    local tc=tg:GetFirst()
    local eqg=Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_GRAVE|LOCATION_HAND|LOCATION_DECK|LOCATION_REMOVED,0,nil,tc)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,eqg,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local loc=LOCATION_HAND|LOCATION_GRAVE
    if Duel.IsExistingMatchingCard(s.filter1c,tp,LOCATION_MZONE|LOCATION_GRAVE,0,1,nil) then
        loc=loc|LOCATION_DECK|LOCATION_REMOVED
    end
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1b),tp,loc,0,1,1,nil,tc)
        if #g>0 then
            Duel.Equip(tp,g:GetFirst(),tc)
        end
    end
end