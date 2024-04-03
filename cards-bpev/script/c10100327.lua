if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Aki Nuva
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c)
    --Destroy if replaced
    local e1=bcot.kanohi_selfdestruct(c)
    c:RegisterEffect(e1)
    --Indestructible by battle
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetCondition(s.condition)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --ATK gain
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetCondition(s.condition)
    e3:SetValue(1000)
    c:RegisterEffect(e3)
    --Piercing
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_PIERCE)
    e4:SetCondition(s.condition)
    c:RegisterEffect(e4)
    --Attack All
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_ATTACK_ALL)
    e5:SetCondition(s.condition)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    --Xyz
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,0))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.condition6)
	e6:SetTarget(s.target6)
	e6:SetOperation(s.operation6)
    e6:SetCountLimit(1)
    c:RegisterEffect(e6)
end
function s.condition(e)
    return bcot.kanohi_con(e,{0x3b02}) and e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ)
end
function s.condition6(e,tp,eg,ep,ev,re,r,rp)
    return bcot.kanohi_con(e,{0x3b02}) and e:GetHandler():GetEquipTarget():IsType(TYPE_FUSION)
end
function s.filter6a(c,e,tp)
    return c:IsSetCard(0x3b02) and c:IsType(TYPE_FUSION) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false)
end
function s.filter6b(c,tp,sg)
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
    return c:IsSetCard(0xb02) and c:IsXyzSummonable(sg:GetFirst(),Group.Merge(g,sg)) and Duel.GetLocationCountFromEx(tp,tp,Group.Merge(g,sg),c)>0
end
function s.filter6c(c,e,tp,lv)
    return s.filter6a(c,e,tp) and Duel.IsExistingMatchingCard(s.filter6b,tp,LOCATION_EXTRA,0,1,nil,tp,Group.FromCards(c))
end
function s.target6(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter6c,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation6(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter6a,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local xyzg=Duel.SelectMatchingCard(tp,s.filter6b,tp,LOCATION_EXTRA,0,1,1,nil,tp,g)
        if xyzg:GetCount()>0 then
            Duel.BreakEffect()
            Duel.XyzSummon(tp,xyzg:GetFirst(),g:GetFirst())
        end
    end
end
