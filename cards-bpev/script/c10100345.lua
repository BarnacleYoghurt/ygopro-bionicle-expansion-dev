--Bohrok Kalifornication
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetCost(s.cost0)
    c:RegisterEffect(e0)
    --Activate in same turn
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetValue(function(e,c) e:SetLabel(1) end) -- set label to 1 to indicate this needed to be checked (=> same turn activation applies)
	e1:SetCondition(function(e) return Duel.GetMatchingGroup(s.filter1,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil):GetClassCount(Card.GetCode) > 1 end)
	c:RegisterEffect(e1)
    e0:SetLabelObject(e1)
    --Special Summon and attach
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(function() return Duel.IsMainPhase() end)
    e2:SetCost(s.cost2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetHintTiming(TIMING_MAIN_END)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
function s.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
        e:GetLabelObject():SetLabel(0) -- ensure label is 0 at this point
        return true
    end
    -- If label has been set to 1 again, we must be in a situation where the cost is required
	if e:GetLabelObject():GetLabel()>0 then
		e:GetLabelObject():SetLabel(0)
		local g=aux.SelectUnselectGroup(Duel.GetMatchingGroup(s.filter1,tp,LOCATION_EXTRA,0,nil),e,tp,2,2,aux.dncheck,1,tp,HINTMSG_REMOVE)
        if #g==2 then
            Duel.Remove(g,POS_FACEUP,REASON_COST)
        end
	end
end
function s.filter1(c)
    return c:IsSetCard(0xb0a) and c:IsAbleToRemoveAsCost()
end
function s.filter2a(c)
    return (c:IsSetCard(0xb08) or c:IsSetCard(0xb09)) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function s.filter2b(c)
    return c:IsSetCard(0xb08) and c:IsType(TYPE_MONSTER)
end
function s.filter2c(c,e,tp)
    --TODO: In MR4, can you send the monster blocking the EMZ to activate this??? 
    return c:IsSetCard(0xb08) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
    local g=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(s.filter2b,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.filter2c,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    Duel.SelectTarget(tp,s.filter2b,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter2c,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if #g>0 then
        local tg=Duel.GetTargetCards(e)
        if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and #tg>0 then
            Duel.Overlay(g:GetFirst(),tg)
        end
    end
end