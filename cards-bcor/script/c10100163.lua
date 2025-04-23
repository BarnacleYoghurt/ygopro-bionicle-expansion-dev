--Fikou-Nui, Tarantula Rahi
local s,id=GetID()
function s.initial_effect(c)
    --Link Summon
    Link.AddProcedure(c,s.filter0,1,1)
    c:EnableReviveLimit()
    --To hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(Cost.SelfTribute)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    c:RegisterEffect(e2)
end
function s.filter0(c,lc,sumtype,tp)
	return c:IsLevelBelow(2) and c:IsSetCard(0xb06)
end
function s.filter1(c)
    return c:IsSetCard(0xb06) and c:IsMonster() and c:IsAbleToHand()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter1(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) end
    if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(1-tp,tc)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
        if #g>0 then
            Duel.BreakEffect()
            Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
        end
    end
end
function s.filter2(c,e,tp)
    return c:IsLevelBelow(4) and c:IsSetCard(0xb06) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
         return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
            and Duel.GetMZoneCount(tp,e:GetHandler())>0
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
        if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
            local sel=Duel.SelectEffect(tp,
                {true,aux.Stringid(id,2)},
                {sc:IsLevelAbove(2),aux.Stringid(id,3)},
                {true,aux.Stringid(id,4)}
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
    