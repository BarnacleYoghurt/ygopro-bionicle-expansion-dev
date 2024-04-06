if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Nuva Symbol of Frigid Serenity
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Search EP or Kopaka
    local e1=bpev.nuva_symbol_search(c,10100005,aux.Stringid(id,3))
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Banish
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetCondition(s.condition2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
    --Leave field
    local e3=bpev.nuva_symbol_punish(c,s.operation3)
    e3:SetDescription(aux.Stringid(id,2))
    c:RegisterEffect(e3)
end
function s.filter2(c,tp)
    return c:IsPreviousSetCard(0x3b02) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
       and c:GetReasonPlayer()==1-tp
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.filter2,1,nil,tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    local op=Duel.SelectEffect(tp,{#g1>0,aux.Stringid(id,4)},{#g2>0,aux.Stringid(id,5)})
    local g=Group.CreateGroup()
    if op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        g=g1:Select(tp,1,1,nil)
    elseif op==2 then
        g=g2:RandomSelect(tp,1)
    end
    if #g>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_REMOVED,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(id,6)) then
        local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,tp,0,LOCATION_REMOVED,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
        end
    end
end