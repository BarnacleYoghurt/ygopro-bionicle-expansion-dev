--Lava Rat, Blazing Rahi
local s,id=GetID()
function s.initial_effect(c)
    --Reduce
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_LVCHANGE+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1)
    c:RegisterEffect(e1)
    --Destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetCondition(s.condition2)
    e2:SetCost(Cost.SelfBanish)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
s.listed_series={0xb06}
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    for tc in g:Iter() do
        if tc:IsLevelAbove(2) then
            tc:UpdateLevel(-1,RESET_EVENT+RESETS_STANDARD,e:GetHandler())
        end
        tc:UpdateAttack(-math.min(tc:GetAttack(),500),RESET_EVENT+RESETS_STANDARD,e:GetHandler())
    end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    local a,d=Duel.GetBattleMonster(tp)
    return a and d and a:IsSetCard(0xb06) and a:IsFaceup()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local _,d=Duel.GetBattleMonster(tp)
    if chk==0 then return d end
    e:SetLabelObject(d)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:IsRelateToBattle() and tc:IsControler(1-tp) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end

