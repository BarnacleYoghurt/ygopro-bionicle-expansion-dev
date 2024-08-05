--Fikou-Nui, Tarantula Rahi
local s,id=GetID()
function s.initial_effect(c)
    --Link Summon
    Link.AddProcedure(c,s.filter0,1,1)
    c:EnableReviveLimit()
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(aux.selfreleasecost)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
end
function s.filter0(c,lc,sumtype,tp)
	return c:IsLevelBelow(2) and c:IsSetCard(0xb06)
end
function s.filter1(c,e,tp)
    return c:IsLevelBelow(4) and c:IsSetCard(0xb06) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
         return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
            and Duel.GetMZoneCount(tp,e:GetHandler())>0
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
        if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
            local sel=Duel.SelectEffect(tp,
                {true,aux.Stringid(id,1)},
                {sc:IsLevelAbove(2),aux.Stringid(id,2)},
                {true,aux.Stringid(id,3)}
            )
            if sel==1 then
                sc:UpdateLevel(1,RESET_EVENT+RESETS_STANDARD,e:GetHandler())
            elseif sel==2 then
                sc:UpdateLevel(-1,RESET_EVENT+RESETS_STANDARD,e:GetHandler())
            end
        end
        Duel.SpecialSummonComplete()
    end
end
    