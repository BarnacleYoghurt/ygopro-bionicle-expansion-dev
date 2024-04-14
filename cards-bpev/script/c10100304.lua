--Nuva Rank-Up-Magic Protodermic Evolution
local s,id=GetID()
function s.initial_effect(c)
    --Rankup
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
end
function s.filter1a(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
    if not (#pg<=1 and c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsOriginalSetCard(0xb02)) then return end
    if c:GetRank()>0 or c:IsStatus(STATUS_NO_LEVEL) then
        return Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+2,pg)
    end
    if c:GetLevel()>=2 then
        return Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetLevel()-2,pg)
    end
end
function s.filter1b(c,e,tp,mc,rk,pg)
	if c.rum_limit and not c.rum_limit(mc,e) or Duel.GetLocationCountFromEx(tp,tp,mc,c)<=0 then return false end
	return c:IsType(TYPE_XYZ) and c:IsRank(rk) and c:IsRace(RACE_WARRIOR) and mc:IsCanBeXyzMaterial(c,tp) and (#pg<=0 or pg:IsContains(mc))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.filter1a(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
    if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or not tc:IsRace(RACE_WARRIOR) or tc:IsImmuneToEffect(e) or #pg>1 or (#pg==1 and not pg:IsContains(tc)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g
    if tc:GetRank()>0 or tc:IsStatus(STATUS_NO_LEVEL) then
        g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+2,pg)
    elseif tc:GetLevel()>=2 then
        g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetLevel()-2,pg)
    end
    local sc=g:GetFirst()
    if sc then
        sc:SetMaterial(tc)
        Duel.Overlay(sc,tc)
        if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
            sc:CompleteProcedure()
            if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,Group.FromCards(sc,e:GetHandler())) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
                local og=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,Group.FromCards(sc,e:GetHandler()))
                if #og>0 then
                    Duel.Overlay(sc,og)
                end
            end
        end
    end
end