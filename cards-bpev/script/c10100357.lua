--Bohrok Silver Shield
local s,id=GetID()
function s.initial_effect(c)
    --Attach
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Shield
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
function s.filter1a(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0xb08) and c:IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,c)
end
function s.filter1b(c,tc)
    return c:IsSetCard(0xb09) and c:IsMonster()
        and c~=tc -- you know, for the totally real Bohrok/Krana hybrid
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter1a(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1b),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tc)
        if #g>0 then
            Duel.Overlay(tc,g,true)
        end
    end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTarget(aux.TargetBoolFunction(s.filter2_1a))
    e1:SetValue(function (e_,re_) return e_:GetHandler()~=re_:GetOwner() end)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function s.filter2_1a(c)
    return c:IsSetCard(0xb08) and c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(s.filter2_1b,1,nil)
end
function s.filter2_1b(c)
    return c:IsSetCard(0xb09) and c:IsType(TYPE_LINK)
end