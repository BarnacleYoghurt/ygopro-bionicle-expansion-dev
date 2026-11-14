Duel.LoadScript("util-bmol.lua")
--Matoran Kolhii Champions
local s,id=GetID()
function s.initial_effect(c)
    --Link Summon
    Link.AddProcedure(c,nil,2,2,s.check0)
    c:EnableReviveLimit()
    --Change Attribute
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.value1)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(s.condition2)
    e2:SetOperation(s.operation2)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --Direct attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_DIRECT_ATTACK)
    e3:SetCondition(s.condition3)
    c:RegisterEffect(e3)
    --Add to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_TOHAND|CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(s.target4)
    e4:SetOperation(s.operation4)
    e4:SetCountLimit(1,id)
    c:RegisterEffect(e4)
end
function s.check0(g,lc)
    return g:CheckSameProperty(Card.GetAttribute) and g:IsExists(Card.IsRace,1,nil,RACE_WARRIOR)
end
function s.value1(e,c)
	local g=c:GetMaterial()
	if g then
        -- core bug: total=0 won't get you anything no matter how much you & to it...
        -- until that's fixed, that means no
        --e:SetLabel(g:GetBitwiseAnd(Card.GetAttribute))
        -- and instead
        local attr=ATTRIBUTE_ALL
        for tc in g:Iter() do
            attr=attr & tc:GetAttribute()
        end
        e:SetLabel(attr)
    end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLinkSummoned() and e:GetLabelObject():GetLabel()~=0
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local attr=e:GetLabelObject():GetLabel()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e1:SetValue(attr)
    e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
    c:RegisterEffect(e1)
end
function s.condition3(e)
    local g=e:GetHandler():GetColumnGroup()
    return not Duel.IsExistingMatchingCard(function(c) return g:IsContains(c) end,
        e:GetHandlerPlayer(),0,LOCATION_MZONE,1,e:GetHandler())
end
function s.filter4(c)
    return (c:IsCode(CARD_KLHI_FIELD) or c:IsCode(CARD_KLHI_STICK))
        and c:IsAbleToHand()
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND|LOCATION_ONFIELD)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.filter4,tp,LOCATION_DECK,0,nil)
    if #g>0 then
        local sg=aux.SelectUnselectGroup(g,e,tp,1,2,
            function(cg) return cg:CheckDifferentProperty(Card.GetCode) end,
            1,tp,HINTMSG_ATOHAND)
        if Duel.SendtoHand(sg,tp,REASON_EFFECT)>0 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local gg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,1,nil)
            if #gg>0 then Duel.SendtoGrave(gg,REASON_EFFECT) end
        end
    end
end