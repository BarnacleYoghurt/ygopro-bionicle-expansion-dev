Duel.LoadScript("util-bmol.lua")
--Shattering Kraata Xi
local s,id=GetID()
function s.initial_effect(c)
    --Add to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SEARCH|CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    local e1b=e1:Clone()
    e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e1b)
    --Cannot be destroyed by battle
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Shatter
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_DAMAGE_STEP_END)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    c:RegisterEffect(e3)
end
function s.filter1(c)
    return c:IsSetCard(SET_KRAATA) and c:IsMonster() and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function s.filter3(c,tc,seq,tp)
    -- only counts cards opponent controls
    if not c:IsControler(1-tp) then return false end
    -- still have to check controller of tc after this because it may change before resolution!
    if c:IsLocation(LOCATION_SZONE) then
        return tc:IsInMainMZone() and tc:GetColumnGroup():IsContains(c) and tc:IsControler(1-tp)
    elseif c:IsInExtraMZone() or tc:IsInExtraMZone() then
        return tc:GetColumnGroup():IsContains(c)
    else
        return c:IsSequence(seq+1,seq-1) and tc:IsControler(1-tp)
    end
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if chk==0 then return tc and tc:IsRelateToBattle() and tc:IsAttackBelow(800*c:GetLevel()) end
    local g=tc:GetColumnGroup(1,1):Filter(s.filter3,nil,tc,tc:GetSequence(),tp)
    g:Merge(tc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    if tc:IsRelateToBattle() then
        local g=tc:GetColumnGroup(1,1):Filter(s.filter3,nil,tc,tc:GetSequence(),tp)
        if Duel.Destroy(tc,REASON_EFFECT)>0 and #g>0 then
            Duel.BreakEffect()
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
    e:GetHandler():UpdateLevel(1)
end