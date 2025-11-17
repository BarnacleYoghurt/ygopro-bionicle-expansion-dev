if not bpev then
    Duel.LoadScript("util-bpev.lua")
end
--Bohrok Kohrak-Kal
local s,id=GetID()
function s.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
    c:EnableReviveLimit()
    --Xyz Material
    Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb08),4,2)
    --Materials to Deck
    local e1=bpev.bohrok_kal_xmat(c)
    c:RegisterEffect(e1)
    --Attach
    local e2=bpev.bohrok_kal_attach(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCountLimit(1)
    c:RegisterEffect(e2)
    --Sonic Boom
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(TIMING_MAIN_END)
    e3:SetCondition(function() return Duel.IsMainPhase() end)
    e3:SetCost(Cost.DetachFromSelf(2))
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1,id)
    c:RegisterEffect(e3)
end
s.listed_series={0xb08,0xb09}
function s.filter3(c)
    return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(aux.OR(s.filter3,Card.IsNegatableMonster),tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
    local g=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,c)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g1=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,c)
    local g2=Duel.GetMatchingGroup(Card.IsNegatableMonster,tp,LOCATION_MZONE,LOCATION_MZONE,c)
    Duel.ChangePosition(g1,POS_FACEUP_DEFENSE)
    for tc in aux.Next(g2) do
        tc:NegateEffects(c,RESET_PHASE+PHASE_END)
    end
end

