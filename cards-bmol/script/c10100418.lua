--Onu-Matoran Ussalry
local s,id=GetID()
function s.initial_effect(c)
    --Synchro Summon
    Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99,s.tunersub)
	c:EnableReviveLimit()
    --ATK/DEF reduction
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetCondition(s.condition1)
    e1:SetValue(s.value1)
    c:RegisterEffect(e1)
    local e1b=e1:Clone()
    e1b:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e1b)
    --Multi attack
    aux.GlobalCheck(s,function()
        local ge=Effect.CreateEffect(c)
        ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
        ge:SetCode(EVENT_PAY_LPCOST)
        ge:SetOperation(s.checkop_paid)
        Duel.RegisterEffect(ge,0)
    end)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(s.value2)
    c:RegisterEffect(e2)
    --Return to deck
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCost(Cost.Discard())
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1)
    c:RegisterEffect(e3)
end
function s.tunersub(c,scard,sumtype,tp)
    return c:IsAttribute(ATTRIBUTE_EARTH,scard,sumtype,tp)
       and c:IsRace(RACE_WARRIOR,scard,sumtype,tp)
end
function s.checkop_paid(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
end
function s.condition1(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function s.value1(e,c)
    local tp=e:GetHandlerPlayer()
    return Duel.GetLP(1-tp)-Duel.GetLP(tp)
end
function s.value2(e,c)
    local tp=e:GetHandlerPlayer()
    return Duel.GetFlagEffect(tp,id)>0
end
function s.filter3(c)
    return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and c:IsAbleToDeck()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE|LOCATION_REMOVED)
    Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tc=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,1,nil):GetFirst()
    if tc and Duel.SendtoDeck(tc,tp,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and
       tc:IsLocation(LOCATION_DECK) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,aux.TRUE,1-tp,LOCATION_ONFIELD,0,1,1,nil)
        if #g>0 then
            Duel.BreakEffect()
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
end