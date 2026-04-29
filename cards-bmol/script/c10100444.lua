Duel.LoadScript("util-bmol.lua")
--Panrahk, Fragmentation Rahkshi
local s,id=GetID()
function s.initial_effect(c)
	 --Fusion Material
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,10100434,s.filter0)
    --Kaboom
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Special Summon
    local e2a=Effect.CreateEffect(c)
    e2a:SetDescription(aux.Stringid(id,1))
    e2a:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2a:SetProperty(EFFECT_FLAG_DELAY)
    e2a:SetCode(EVENT_BATTLE_DESTROYED)
    e2a:SetTarget(s.target2)
    e2a:SetOperation(s.operation2)
    e2a:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2a)
    local e2b=e2a:Clone()
    e2b:SetCode(EVENT_TO_GRAVE)
    e2b:SetCondition(s.condition2)
    c:RegisterEffect(e2b)
end
function s.filter0(c,fc,sumtype,tp)
    return c:IsRace(RACE_FIEND,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp)
        and c:GetLevel()>=4
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
    if tc and Duel.Destroy(tc,REASON_EFFECT)>0 and tc:IsPreviousLocation(LOCATION_MZONE) and tc:GetTextAttack()>0 then
        Duel.Damage(1-tp,tc:GetTextAttack(),REASON_EFFECT)
    end
end
function s.filter2(c,e,tp)
    return c:IsSetCard(SET_KRAATA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter2),tp,LOCATION_HAND|LOCATION_GRAVE,0,1,nil,e,tp)
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),2)
    if ft==0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
    if ft>0 then
        local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter2),tp,LOCATION_HAND|LOCATION_GRAVE,0,nil,e,tp)
        local sg=aux.SelectUnselectGroup(g,e,tp,1,ft,aux.dpcheck(Card.GetLocation),1,tp,HINTMSG_SPSUMMON)
        if #sg>0 then
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end