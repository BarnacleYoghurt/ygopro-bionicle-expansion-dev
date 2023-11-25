if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Bohrok Lehvak-Kal
local s,id=GetID()
function s.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
    c:EnableReviveLimit()
    --Xyz Material
    Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb08),4,2)
    --Materials to Deck
    local e1=bpev.bohrok_kal_xmat(c)
    c:RegisterEffect(e1)
    --succ
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetHintTiming(TIMING_END_PHASE)
    e2:SetCountLimit(1)
    c:RegisterEffect(e2)
    --blow
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.condition3)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1,id)
    c:RegisterEffect(e3)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return (chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE)) or chkc:IsLocation(LOCATION_GRAVE) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
	    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
    end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        Duel.Overlay(c,tc,true)
    end
end
function s.filter3(c)
    return c:IsFaceup() and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>=4
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetOverlayCount()>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
    local g=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,c:GetOverlayCount(),0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local og=c:GetOverlayGroup()
        local ct=Duel.SendtoGrave(og,REASON_EFFECT)
        if ct>0 then
            local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
            if #g>0 then
                Duel.Destroy(g,REASON_EFFECT)
                local dg=Duel.GetOperatedGroup():Filter(aux.NecroValleyFilter(s.filter3),nil)
                if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
                    Duel.BreakEffect()
                    local ag=dg:Select(tp,1,1,nil)
                    Duel.Overlay(c,ag,true)
                end
            end
        end
    end
end

