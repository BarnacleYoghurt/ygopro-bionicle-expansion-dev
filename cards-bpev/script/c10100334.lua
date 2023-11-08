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
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetCost(aux.dxmcostgen(1,1))
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1,id)
    c:RegisterEffect(e3)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetHandler():GetBattleTarget()
    if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove() end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    if tc and tc:IsRelateToBattle() then
        local atk=tc:GetBaseAttack()
        if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
            Duel.Damage(1-tp,atk,REASON_EFFECT)
        end
    end
end
