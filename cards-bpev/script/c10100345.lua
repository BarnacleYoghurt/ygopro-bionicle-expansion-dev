--Bohrok Kalifornication
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetCost(s.cost0)
    e0:SetTarget(s.target0)
    e0:SetHintTiming(TIMING_MAIN_END)
    c:RegisterEffect(e0)
    --Activate in same turn
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetValue(function(e,c) e:SetLabel(1) end) -- set label to 1 to indicate this needed to be checked (=> same turn activation applies)
	e1:SetCondition(s.condition1)
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
    e1:SetLabelObject(e2) -- we need to get it to e0 but the direct slot is taken, so ...
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
function s.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    -- Because the activation has a cost function, the default mechanism for using the effect in the same chain link does not apply
    -- Instead we have to manually provide that option here
    if chck then s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
    if chk==0 then return true end
    local e0=e:GetLabelObject():GetLabelObject()
    if Duel.IsMainPhase() and s.cost2(e,tp,eg,ep,ev,re,r,rp,0)
        and s.target2(e,tp,eg,ep,ev,re,r,rp,0) and e0:CheckCountLimit(tp)
        and Duel.SelectYesNo(tp,94) then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e:SetOperation(s.operation2)
        s.cost2(e,tp,eg,ep,ev,re,r,rp,1)
        s.target2(e,tp,eg,ep,ev,re,r,rp,1)
        e0:UseCountLimit(tp)
    end
end
function s.filter1(c)
    return c:IsSetCard(0xb0a) and c:IsAbleToRemoveAsCost()
end
function s.condition1(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
        and Duel.GetMatchingGroup(s.filter1,tp,LOCATION_EXTRA,0,nil):GetClassCount(Card.GetCode) > 1
end
function s.filter2a(c,e,tp)
    return (c:IsSetCard(0xb08) or c:IsSetCard(0xb09)) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(s.filter2c,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.filter2b(c)
    return c:IsSetCard(0xb08) and c:IsType(TYPE_MONSTER)
end
function s.filter2c(c,e,tp,sc)
    return c:IsSetCard(0xb08) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp) end
    local g=Duel.SelectMatchingCard(tp,s.filter2a,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(s.filter2b,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectTarget(tp,s.filter2b,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter2c,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if #g>0 then
        local tg=Duel.GetTargetCards(e)
        if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
            local tc=g:GetFirst()
            if #tg>0 then
                Duel.Overlay(tc,tg)
            end

            local c=e:GetHandler()
            local fid=c:GetFieldID()
            tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,2))
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e1:SetCode(EVENT_PHASE+PHASE_END)
            e1:SetLabel(fid)
            e1:SetLabelObject(tc)
            e1:SetCondition(s.condition2_1)
            e1:SetOperation(s.operation2_1)
            e1:SetCountLimit(1)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
function s.condition2_1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsTurnPlayer(tp) then return false end
	if e:GetLabelObject():GetFlagEffectLabel(id)==e:GetLabel() then return true end
	e:Reset()
	return false
end
function s.operation2_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end