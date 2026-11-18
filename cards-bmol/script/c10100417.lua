Duel.LoadScript("util-bmol.lua")
--Matoran Prospector Azibo
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_TO_HAND)
    e1:SetCost(s.cost1)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Reduce Level
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_LVCHANGE|CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
    --Excavate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_DECKDES)
    e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1,{id,2})
    c:RegisterEffect(e3)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
           and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRelateToEffect(e)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
           and chkc:IsFaceup() and chkc:IsLevelAbove(3)
    end
    if chk==0 then return Duel.IsExistingTarget(aux.FaceupFilter(Card.IsLevelAbove,3),tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,aux.FaceupFilter(Card.IsLevelAbove,3),tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLevelAbove(2) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
        local lv=1
        if tc:IsLevelAbove(3) then lv=Duel.AnnounceNumber(tp,1,2) end
        if tc:UpdateLevel(-lv,RESET_EVENT|RESETS_STANDARD,c)~=0 then
            Duel.Recover(tp,600,REASON_EFFECT)
        end
    end
end
function s.filter3(c)
    return c:IsFaceup() and (c:IsSetCard(SET_TOA) or c:IsSetCard(SET_MATORAN) or c:IsSetCard(SET_TURAGA))
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetMatchingGroupCount(s.filter3,tp,LOCATION_MZONE,0,nil)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(s.filter3,tp,LOCATION_MZONE,0,nil)
    if ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct then
        Duel.ConfirmDecktop(tp,ct)
        Duel.DisableShuffleCheck()
        local g=Duel.GetDecktopGroup(tp,ct)
        local fg=g:Filter(Card.IsSSetable,nil)
        if #fg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
            local sc=fg:Select(tp,1,1,nil)
            if sc then
                Duel.SSet(tp,sc)
                g=g-sc
            end
        end
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end