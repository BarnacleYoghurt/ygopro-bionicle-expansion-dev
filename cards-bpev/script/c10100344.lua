if not bpev then
    Duel.LoadScript("util-bpev.lua")
end
--Krana Bo-Kal, Visionary
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
    --Special Summon
    local e2=bpev.krana_kal_ssummon(c)
    e2:SetDescription(aux.Stringid(id,0))
    c:RegisterEffect(e2)
    --Look
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
    e3:SetCondition(s.condition3)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1)
    c:RegisterEffect(e3)
end
s.listed_series={0xb08,0xb09}
function s.filter0(c)
  return c:IsSetCard(0xb08) or c:IsSetCard(0xb09)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSetCard(0xb08)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil)
            or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
    end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    --Set Cards
    local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
    if #g1>0 then
        Duel.ConfirmCards(tp,g1)
    end
    --Hand
    local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    local ct=math.min(#g2, Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,0xb08),tp,LOCATION_MZONE,0,nil))
    if ct>0 then
        g2=g2:RandomSelect(tp,ct)
        Duel.ConfirmCards(tp,g2)
        Duel.ShuffleHand(1-tp)
    end
end

