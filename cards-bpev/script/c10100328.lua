if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Rua Nuva
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c)
    --Destroy if replaced
    local e1=bcot.kanohi_selfdestruct(c)
    c:RegisterEffect(e1)
    --Immune
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetCondition(s.condition)
    e2:SetValue(s.value2)
    c:RegisterEffect(e2)
    --Hand Reveal
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(0,LOCATION_HAND)
    e3:SetCode(EFFECT_PUBLIC)
    e3:SetCondition(s.condition)
    c:RegisterEffect(e3)
    --Xyz
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.condition4)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation4)
    e4:SetCountLimit(1)
    c:RegisterEffect(e4)
end
function s.condition(e)
    return bcot.kanohi_con(e,{0x3b02}) and e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ)
end
function s.value2(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function s.condition4(e,tp,eg,ep,ev,re,r,rp)
    return bcot.kanohi_con(e,{0x3b02}) and e:GetHandler():GetEquipTarget():IsType(TYPE_FUSION)
end
function s.filter4a(c,e,tp)
    return c:IsSetCard(0x3b02) and c:IsType(TYPE_FUSION) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false)
end
function s.filter4b(c,tp,sg)
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
    return c:IsSetCard(0xb02) and c:IsXyzSummonable(sg:GetFirst(),Group.Merge(g,sg)) and Duel.GetLocationCountFromEx(tp,tp,Group.Merge(g,sg),c)>0
end
function s.filter4c(c,e,tp,lv)
    return s.filter4a(c,e,tp) and Duel.IsExistingMatchingCard(s.filter4b,tp,LOCATION_EXTRA,0,1,nil,tp,Group.FromCards(c))
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter4c,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter4a,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local xyzg=Duel.SelectMatchingCard(tp,s.filter4b,tp,LOCATION_EXTRA,0,1,1,nil,tp,g)
        if xyzg:GetCount()>0 then
            Duel.BreakEffect()
            Duel.XyzSummon(tp,xyzg:GetFirst(),g:GetFirst())
        end
    end
end