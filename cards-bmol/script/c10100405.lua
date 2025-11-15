Duel.LoadScript("util-bmol.lua")
--Pewku, Avohkii-Bearing Rahi
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Xyz Summon
    Xyz.AddProcedure(c,nil,4,2)
    --Set
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(Cost.DetachFromSelf(1))
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
s.listed_names={CARD_AVOHKII}
function s.filter1(c)
    return c:IsSpellTrap() and c:ListsCode(CARD_AVOHKII) and not c:IsType(TYPE_EQUIP) and c:IsSSetable()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SSet(tp,g)
    end

    -- Cannot Special Summon from Extra Deck, except monsters that mention Avohkii
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(id,2))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
    e1:SetTargetRange(1,0)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTarget(function (e,c) return c:IsLocation(LOCATION_EXTRA) and not c:ListsCode(CARD_AVOHKII) end)
    e1:SetReset(RESET_PHASE|PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function s.filter2(c,e,tp)
    return c:IsFaceup() and c:IsLevel(4) and c:IsSetCard(SET_AVOHKII) and c:IsControler(tp)
        and not c:IsType(TYPE_TOKEN) and c:IsCanBeEffectTarget(e)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=eg:Filter(s.filter2,nil,e,tp)
    if chkc then return tg:IsContains(chkc) end
    local c=e:GetHandler()
    if chk==0 then return #tg>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=tg:Select(tp,1,1,nil)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
        and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(c,tc,true)
    end
end
