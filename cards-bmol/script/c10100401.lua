Duel.LoadScript("util-bmol.lua")
--Matoran Jaller, Avohkii Herald
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)
    --Search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SEARCH|CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
    local e2b=e2:Clone()
    e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2b)
end
s.listed_names={CARD_AVOHKII}
function s.filter1(c)
    return c:IsCode(CARD_AVOHKII) and not c:IsPublic()
end
function s.condition1(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,0,1,nil)
    if #g>0 then
        g:KeepAlive()
        e:SetLabelObject(g)
        return true
    end
    return false
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
    g:DeleteGroup()
end
function s.filter2(c)
    return c:ListsCode(CARD_AVOHKII) and c:IsAbleToHand()
        and not c:IsCode(id) and not c:IsEquipSpell()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil)  end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end


