Duel.LoadScript("util-bmol.lua")
--Matoran Takua, Avohkii Chronicler
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(s.cost1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
s.listed_names={CARD_AVOHKII}
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,aux.NOT(Card.IsPublic),tp,LOCATION_HAND,0,1,1,e:GetHandler())
    Duel.ConfirmCards(1-tp,g)
    e:SetLabelObject(g:GetFirst())
    g:GetFirst():CreateEffectRelation(e)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    Duel.SetPossibleOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=e:GetLabelObject()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 and rc:IsRelateToEffect(e)
            and Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.ListsCode,CARD_AVOHKII),tp,LOCATION_ONFIELD,0,nil)<2 then
            Duel.BreakEffect()
            Duel.SendtoGrave(rc,REASON_EFFECT)
        end
    end
end
function s.filter2a(c,tp)
    return c:IsSetCard(SET_AVOHKII) and c:IsEquipSpell()
        and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_MZONE,0,1,nil,c)
end
function s.filter2b(c,ec)
    return c:IsFaceup() and c:IsSetCard(SET_AVOHKII) and ec:CheckEquipTarget(c)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,nil,tp)
            and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2a),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,tp)
        if #g1>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
            local g2=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_MZONE,0,1,1,nil,g1:GetFirst())
            if #g2>0 then
                Duel.Equip(tp,g1:GetFirst(),g2:GetFirst())
            end
        end
    end
end

