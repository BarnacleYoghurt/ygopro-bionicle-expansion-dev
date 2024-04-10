--Tales of the Nuva
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Set
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,2})
    c:RegisterEffect(e2)
    --Special Summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCondition(s.condition3)
    e3:SetCost(s.cost3)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1,{id,3})
    c:RegisterEffect(e3)
end
function s.filter1(c)
    return c:IsSetCard(0xb0b) and c:IsAbleToHand()
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.filter2(c,tp)
    return c:IsSetCard(0xb0c) and c:IsSpellTrap() and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK) and c:IsSSetable()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local pg=eg:Filter(s.filter2,nil,tp)
    if chkc then return pg:IsContains(chkc) end
    if chk==0 then return pg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local tg=pg:Select(tp,1,1,nil)
    Duel.SetTargetCard(tg)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SSet(tp,tc)
    end
end
function s.filter3a(c)
    return c:IsSetCard(0x3b02) and c:IsMonster() and c:IsAbleToExtra()
end
function s.filter3b(c,e,tp,code)
    return c:IsSetCard(0x3b02) and c:IsType(TYPE_FUSION) and not c:IsCode(code)
        and c:IsCanBeSpecialSummoned(e,tp,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsMonsterEffect()
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter3a(chkc) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(s.filter3a,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.filter3a,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)>0
       and Duel.IsExistingMatchingCard(s.filter3b,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetCode())
       and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.filter3b,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end