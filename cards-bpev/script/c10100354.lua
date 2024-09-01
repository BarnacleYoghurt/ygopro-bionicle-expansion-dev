--Place of Shadow
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Special Summon or add
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCost(s.cost1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1)
    c:RegisterEffect(e1)
    --Fusion Summon
    local params={fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0xb06),matfilter=Fusion.OnFieldMat(Card.IsAbleToRemove),extrafil=s.extrafil,extraop=Fusion.BanishMaterial,extratg=s.extratg}
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(function(e) return Duel.GetCurrentPhase()~=PHASE_DAMAGE end)
    e2:SetTarget(Fusion.SummonEffTG(params))
    e2:SetOperation(Fusion.SummonEffOP(params))
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
function s.spcheck1(sg,tp,_,e)
    --check that tributing frees a zone iff adding to hand is not possible
    local rc=sg:GetFirst()
    return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,rc),true
end
function s.filter1(c,e,tp,rc)
    return c:IsSetCard(0xb06) and c:IsType(TYPE_NORMAL)
        and (c:IsAbleToHand() or (Duel.GetMZoneCount(tp,rc)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,1,false,s.spcheck1,nil,e) end
    local g=Duel.SelectReleaseGroupCost(tp,nil,1,1,false,s.spcheck1,nil,e)
    Duel.Release(g,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end --cost already checks for targets (see s.spcheck1)
    Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,nil)
	if #g>0 then
        aux.ToHandOrElse(g,tp,
            function()
                return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
            end,
            function()
                local tc=g:GetFirst()
                if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
                    local e1=Effect.CreateEffect(e:GetHandler())
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
                    e1:SetValue(ATTRIBUTE_DARK)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                    tc:RegisterEffect(e1)
                end
                Duel.SpecialSummonComplete()
            end,
            aux.Stringid(id,3)
        )
    end
end
function s.filter2(c)
    return (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToRemove()
end
function s.extrafil(e,tp,mg)
    local loc=LOCATION_EXTRA
    if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
        loc=loc+LOCATION_GRAVE
    end
    return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(s.filter2),tp,loc,0,nil)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA)
end