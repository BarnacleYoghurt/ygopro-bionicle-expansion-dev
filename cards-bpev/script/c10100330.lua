--Nuva Emergence
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Summon
    local e1=Fusion.CreateSummonEff{handler=c,fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0xb0c),matfilter=Fusion.InHandMat(Card.IsAbleToDeck),
                                    extrafil=s.extrafil,extraop=Fusion.ShuffleMaterial,extratg=s.extratg}
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.condition1)
    c:RegisterEffect(e1)
    --Add Spell/Trap
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(function(e) return aux.exccon(e) and Duel.IsMainPhase() end)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetHintTiming(0,TIMING_MAIN_END)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
function s.extrafil(e,tp,mg)
    return Duel.GetMatchingGroup(aux.NecroValleyFilter(Fusion.IsMonsterFilter(Card.IsAbleToDeck)),tp,LOCATION_GRAVE,0,nil)
        +  Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup),tp,LOCATION_REMOVED,0,nil)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp
end
function s.filter2(c)
    return c:IsSetCard(0xb0c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
        local og=Duel.GetOperatedGroup()
        if og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0 then
            Duel.ConfirmCards(1-tp,g)
            Duel.BreakEffect()
            Duel.ShuffleHand(tp)
            Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
        end
    end
end