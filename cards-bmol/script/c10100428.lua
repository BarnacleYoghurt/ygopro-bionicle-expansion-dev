--The Fall of Ta-Koro
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Wipe
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND|CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCode(EVENT_PHASE|PHASE_END)
    e1:SetCondition(function (e,tp) return Duel.IsTurnPlayer(1-tp) end)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1)
    c:RegisterEffect(e1)
    --Bounce
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND|CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    c:RegisterEffect(e2)
    --Search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_SEARCH|CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(s.condition3)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1,id)
    c:RegisterEffect(e3)
end
s.listed_attributes={ATTRIBUTE_FIRE,ATTRIBUTE_WATER,ATTRIBUTE_EARTH,ATTRIBUTE_WIND,ATTRIBUTE_LIGHT}
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local att=ATTRIBUTE_FIRE|ATTRIBUTE_WATER|ATTRIBUTE_EARTH|ATTRIBUTE_WIND|ATTRIBUTE_LIGHT
    local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttribute,att),tp,LOCATION_MZONE,0,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local att=ATTRIBUTE_FIRE|ATTRIBUTE_WATER|ATTRIBUTE_EARTH|ATTRIBUTE_WIND|ATTRIBUTE_LIGHT
    local hg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttribute,att),tp,LOCATION_MZONE,0,1,nil)
    if #hg>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)>0 and hg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
        local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
        Duel.Destroy(dg,REASON_EFFECT)
    end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local ac=Duel.GetAttacker()
    local dc=Duel.GetAttackTarget()
    if chk==0 then
        return dc and ac:IsAbleToHand() and dc:IsAbleToHand()
           and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,Group.FromCards(ac,dc),2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND|LOCATION_ONFIELD)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local ac=Duel.GetAttacker()
    local dc=Duel.GetAttackTarget()
    if Duel.SendtoHand(Group.FromCards(ac,dc),nil,REASON_EFFECT)==2 and ac:IsLocation(LOCATION_HAND) and dc:IsLocation(LOCATION_HAND) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,1,nil)
        if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
    end
end
function s.filter3(c)
    return c:IsType(TYPE_FIELD) and not c:IsSetCard(0xb05) and c:IsAbleToHand()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_FZONE)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end