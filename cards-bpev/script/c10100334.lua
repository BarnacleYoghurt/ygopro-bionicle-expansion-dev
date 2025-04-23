if not bpev then
    Duel.LoadScript("util-bpev.lua")
end
--Bohrok Pahrak-Kal
local s,id=GetID()
function s.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
    c:EnableReviveLimit()
    --Xyz Material
    Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb08),4,2)
    --Materials to Deck
    local e1=bpev.bohrok_kal_xmat(c)
    c:RegisterEffect(e1)
    --Attach
    local e2=bpev.bohrok_kal_attach(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCountLimit(1)
    c:RegisterEffect(e2)
    --Banish
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetCost(Cost.Detach(1))
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1,id)
    c:RegisterEffect(e3)
end
s.listed_series={0xb08,0xb09}
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsAbleToRemove() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
    local tc=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
    local tg=(tc+tc:GetColumnGroup()):Filter(Card.IsAbleToRemove,nil):Filter(Card.IsControler,nil,1-tp)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,#tg,0,0)
    if #tg==1 then
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
    end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local tg=(tc+tc:GetColumnGroup()):Filter(Card.IsAbleToRemove,nil):Filter(Card.IsControler,nil,1-tp)
        if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==1 and tg:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)==1 then
            Duel.BreakEffect()
            Duel.Damage(1-tp,1200,REASON_EFFECT)
        end
    end
end
