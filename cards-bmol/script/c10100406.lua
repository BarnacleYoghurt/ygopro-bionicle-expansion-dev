Duel.LoadScript("util-bmol.lua")
--Ka, Avohkii-Bearing Rahi
local s,id=GetID()
function s.initial_effect(c)
    --Link Summon
    Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2,2,s.check0)
    c:EnableReviveLimit()
    --Draw or Destroy
    local e1a=Effect.CreateEffect(c)
    e1a:SetDescription(aux.Stringid(id,0))
    e1a:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
    e1a:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
    e1a:SetProperty(EFFECT_FLAG_DELAY)
    e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1a:SetCost(s.cost1)
    e1a:SetTarget(s.target1)
    e1a:SetOperation(s.operation1)
    e1a:SetCountLimit(1,id)
    c:RegisterEffect(e1a)
    local e1b=e1a:Clone()
    e1b:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
    e1b:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
    e1b:SetRange(LOCATION_MZONE)
    e1b:SetCondition(s.condition1)
    c:RegisterEffect(e1b)
    --Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCondition(s.condition2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
s.listed_names={CARD_AVOHKII}
function s.check0(g,lc)
    return g:CheckDifferentPropertyBinary(Card.GetAttribute)
end
function s.filter1(c)
    return (c:IsCode(CARD_AVOHKII) or (c:IsSetCard(0xb06) and c:IsRace(RACE_BEAST|RACE_WINGEDBEAST)))
        and not c:IsPublic()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local op=Duel.SelectEffect(tp,
        {Duel.IsPlayerCanDraw(tp,1),aux.Stringid(id,2)},
        {true,aux.Stringid(id,3)})
    e:SetLabel(op)
    if op==1 then
        e:SetCategory(CATEGORY_DRAW)
        Duel.SetTargetPlayer(tp)
        Duel.SetTargetParam(1)
        Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    elseif op==2 then
        e:SetCategory(CATEGORY_DESTROY)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
    end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local op=e:GetLabel()
    if op==1 then
        local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Draw(p,d,REASON_EFFECT)
    elseif op==2 then
        local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
        local dg=aux.SelectUnselectGroup(g,e,tp,1,2,aux.TRUE,1,tp,HINTMSG_DESTROY,
            function(sg) return sg:IsExists(Card.IsControler,1,nil,tp) end)
        Duel.Destroy(dg,REASON_EFFECT)
    end
end
function s.filter2(c,e,tp)
    return c:IsLevel(4) and c:IsSetCard(SET_AVOHKII) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and c:IsCanBeEffectTarget(e)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and (r&REASON_EFFECT+REASON_BATTLE)~=0
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
    if chkc then return g:IsContains(chkc) end
    local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),2)
    if chk==0 then return #g>0 and ft>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=aux.SelectUnselectGroup(g,e,tp,1,ft,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
    Duel.SetTargetCard(tg)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,#tg,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetTargetCards(e)
    if #tg>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if #tg>0 and ft>0 then
        if #tg>ft then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            tg=tg:Select(tp,ft,ft,nil)
        end
        Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
    end
end