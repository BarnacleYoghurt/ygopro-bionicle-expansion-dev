Duel.LoadScript("util-bmol.lua")
--Panrahk, Fragmentation Rahkshi
local s,id=GetID()
function s.initial_effect(c)
	 --Fusion Material
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,10100434,s.filter0)
    --ATK
    local e1a=Effect.CreateEffect(c)
    e1a:SetType(EFFECT_TYPE_SINGLE)
    e1a:SetCode(EFFECT_MATERIAL_CHECK)
    e1a:SetValue(s.value1)
    c:RegisterEffect(e1a)
    local e1b=Effect.CreateEffect(c)
    e1b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1b:SetCondition(s.condition1)
    e1b:SetOperation(s.operation1)
    e1b:SetLabelObject(e1a)
    c:RegisterEffect(e1b)
    --Kaboom
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
function s.filter0(c,fc,sumtype,tp)
    return c:IsRace(RACE_FIEND,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp)
        and c:GetLevel()>=4
end
function s.value1(e,c)
    local g=e:GetHandler():GetMaterial():Filter(Card.IsCode,nil,10100434)
    e:SetLabel(g:GetSum(Card.GetLevel))
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFusionSummoned()
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --Increase ATK
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(e:GetLabelObject():GetLabel()*600)
    e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
    e:GetHandler():RegisterEffect(e1)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
    if tc and Duel.Destroy(tc,REASON_EFFECT)>0 and tc:IsPreviousLocation(LOCATION_MZONE) and tc:GetTextAttack()>0 then
        Duel.Damage(1-tp,tc:GetTextAttack(),REASON_EFFECT)
    end
end