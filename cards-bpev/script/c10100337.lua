if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Krana Xa-Kal, Liberator
local s,id=GetID()
function s.initial_effect(c)
    --Link Summon
    Link.AddProcedure(c,s.filter0,1,1)
    c:EnableReviveLimit()
    --No Link Material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Xyz Summon
    local e2=bpev.krana_kal_xsummon(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCountLimit(1)
    c:RegisterEffect(e2)
    --Awaken the Bahrag
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_BATTLE_DAMAGE)
    e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep~=tp end)
    e3:SetCondition(s.condition3)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    c:RegisterEffect(e3)
end
function s.filter0(c)
    return c:IsSetCard(0xb08) or c:IsSetCard(0xb09)
end
function s.filter3a(c)
    return c:IsSetCard(0xb0a) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.filter3b(c)
    return c:IsCode(10100234) and c:IsAbleToHand()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSetCard(0xb08)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter3a,tp,LOCATION_REMOVED,0,1,nil) and Duel.CheckPendulumZones(tp) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckPendulumZones(tp) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local pg=Duel.SelectMatchingCard(tp,s.filter3a,tp,LOCATION_REMOVED,0,1,2,nil)
    if #pg>0 then
        local ok=true
        pg:ForEach(function(c) ok=ok and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,false) end)
        if ok and Duel.IsExistingMatchingCard(s.filter3b,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local ag=Duel.SelectMatchingCard(tp,s.filter3b,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
            if #ag>0 then
                Duel.SendtoHand(ag,tp,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,ag)
            end
        end
    end
end