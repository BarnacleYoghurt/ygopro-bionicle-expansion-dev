Duel.LoadScript("util-bmol.lua")
--A Seventh Star
local s,id=GetID()
local COUNTER_SEVEN=0xb03
function s.initial_effect(c)
    c:EnableCounterPermit(COUNTER_SEVEN)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)
    --Place counters
    local e2a=Effect.CreateEffect(c)
    e2a:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
    e2a:SetRange(LOCATION_SZONE)
    e2a:SetCode(EVENT_SUMMON_SUCCESS)
    e2a:SetOperation(s.operation2)
    c:RegisterEffect(e2a)
    local e2b=e2a:Clone()
    e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2b)
    --Draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_PHASE|PHASE_END)
    e3:SetCondition(s.condition3)
    e3:SetCost(Cost.SelfToGrave)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    c:RegisterEffect(e3)
end
s.listed_names={CARD_AVOHKII}
function s.filter1(c,e,tp)
    return c:IsSetCard(SET_AVOHKII) and c:IsFaceup() and c:IsAbleToHand()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter1(chkc,e,tp) and chkc:IsLocation(LOCATION_GRAVE|LOCATION_REMOVED) and chkc:IsControler(tp) end
    if chk==0 then return true end
    if Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        e:SetCategory(CATEGORY_TOHAND)
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,1,nil,e,tp)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    else
        e:SetCategory(0)
        e:SetProperty(0)
    end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
function s.filter2a(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:ListsCode(CARD_AVOHKII)
end
function s.filter2b(c)
    --Garbage Collector uses IsAbleToHandAsCost to check "began the Duel", but that can have false positives here ...
    return c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(s.filter2a,nil,tp)
    local ct=(g:IsExists(Card.IsRace,1,nil,RACE_WARRIOR) and 1 or 0)
            +(g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) and 1 or 0)
            +(g:IsExists(Card.IsLevelAbove,1,nil,7) and 1 or 0)
            +(g:IsExists(s.filter2b,1,nil) and 1 or 0)
    if ct>0 then
        e:GetHandler():AddCounter(COUNTER_SEVEN,ct)
    end
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetCounter(COUNTER_SEVEN)>=7
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND|LOCATION_ONFIELD,0)
    if e:GetHandler():IsLocation(LOCATION_SZONE) then h=h-1 end --not sent for cost yet
    if chk==0 then return h<7 and Duel.IsPlayerCanDraw(tp,7-h) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(7-h)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,7-h)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local h=Duel.GetFieldGroupCount(p,LOCATION_HAND|LOCATION_ONFIELD,0)
    if h<7 then
        Duel.Draw(p,7-h,REASON_EFFECT)
    end
end