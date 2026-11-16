Duel.LoadScript("util-bmol.lua")
--The Principle Of Prosperity
local s,id=GetID()
function s.initial_effect(c)
    --Shuffle and draw
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK|CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Banish and shuffle
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_REMOVE|CATEGORY_TODECK|CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
function s.filter1a(c,e)
    return c:IsCanBeEffectTarget(e) and c:IsAbleToDeck()
end
function s.filter1b(c,tp)
    return c:IsSetCard(SET_TOA) or c:IsSetCard(SET_MATORAN) or c:IsSetCard(SET_TURAGA)
end
function s.rescon1(sg,e,tp,mg)
    return sg:IsExists(s.filter1b,1,nil,tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local g=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and aux.SelectUnselectGroup(g,e,tp,1,3,s.rescon1,0,tp) end
    local tg=aux.SelectUnselectGroup(g,e,tp,1,3,s.rescon1,1,tp,HINTMSG_TODECK,s.rescon1)
    Duel.SetTargetCard(tg)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetTargetCards(e)
    if #tg>0 and Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function s.filter2a(c)
    return c:IsRace(RACE_WARRIOR) and c:IsAbleToRemove()
end
function s.filter2b(c)
    return c:IsFaceup() and c:IsMonster() and c:IsAbleToDeck()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter2a(chkc) end
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tg=Duel.SelectTarget(tp,s.filter2a,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
    Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE|LOCATION_REMOVED)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        aux.RemoveUntil(tc,nil,REASON_EFFECT,PHASE_END,id,e,tp,aux.DefaultFieldReturnOp)
        if tc:IsLocation(LOCATION_REMOVED)
        and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter2b),tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,nil)
        and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2b),tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,3,nil)
            local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
            if ct>0 then
                Duel.Recover(tp,ct*600,REASON_EFFECT)
            end
        end
    end
end
