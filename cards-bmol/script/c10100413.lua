Duel.LoadScript("util-bmol.lua")
--The Principle Of Purity
local s,id=GetID()
function s.initial_effect(c)
    --Negate (Purity)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE|CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Double Attack (Speed)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_DAMAGE_STEP_END)
    e2:SetCondition(s.condition2)
    e2:SetCost(aux.bfgcost)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
function s.filter1(c)
    return (c:IsSetCard(0xb01) or c:IsSetCard(0xb02) or c:IsSetCard(0xb03)) and c:IsNegatableMonster()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then
        return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil)
           and Duel.IsExistingTarget(Card.IsNegatable,tp,0,LOCATION_ONFIELD,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
    local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
    local g2=Duel.SelectTarget(tp,Card.IsNegatable,tp,0,LOCATION_ONFIELD,1,1,nil)
    e:SetLabelObject(g2:GetFirst()) --"that opponent's card"
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetTargetCards(e):Match(Card.IsFaceup,nil):Match(Card.IsCanBeDisabledByEffect,nil,e)
    if #g>0 then
        g:ForEach(Card.NegateEffects,e:GetHandler(),RESET_PHASE|PHASE_END)
        if Duel.GetMatchingGroup(Card.IsMonster,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetAttribute)==1 then
            local tc=e:GetLabelObject()
            if tc:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
                Duel.Destroy(tc,REASON_EFFECT)
            end
        end
    end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    local bc=Duel.GetBattleMonster(tp)
    return bc and bc:IsFaceup() and bc==Duel.GetAttacker() and bc:CanChainAttack() and bc:IsRace(RACE_WARRIOR)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local bc=Duel.GetBattleMonster(tp)
    if bc and bc:IsRelateToBattle() then
        Duel.ChainAttack()
    end
end

