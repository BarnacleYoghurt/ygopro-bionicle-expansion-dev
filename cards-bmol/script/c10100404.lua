Duel.LoadScript("util-bmol.lua")
--Light of the Mask
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --To deck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
s.listed_names={CARD_AVOHKII}
function s.filter1(c)
    return c:IsCode(CARD_AVOHKII) and not c:IsPublic()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsFaceup() and chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,1-tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,1-tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if tc:IsFaceup() and tc:IsControler(1-tp) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(id,2))
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
            e1:SetTargetRange(0,1)
            e1:SetCode(EFFECT_CANNOT_ACTIVATE)
            e1:SetLabel(tc:GetOriginalCode())
            e1:SetValue(function (e,re,tp) return re:GetHandler():IsOriginalCode(e:GetLabel()) end)
            e1:SetReset(RESET_PHASE|PHASE_END)
            Duel.RegisterEffect(e1,tp)
        end
        if Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
            local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil)
            Duel.ConfirmCards(1-tp,g)
            Duel.SendtoGrave(tc,REASON_EFFECT)
        end
    end
end
function s.filter2(c)
    return c:IsSetCard(SET_AVOHKII) and c:IsAbleToDeck()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter2(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) end
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil) and c:IsAbleToDeck() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g+c,2,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
        Duel.SendtoDeck(Group.FromCards(c,tc),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end