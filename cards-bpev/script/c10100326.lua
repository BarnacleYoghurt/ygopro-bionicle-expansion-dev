if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Wairuha, Toa Nuva Kaita of Wisdom
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    c:SetSPSummonOnce(id)
    --Xyz Material
    Xyz.AddProcedure(c,nil,8,3)
    --Negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition1)
	e1:SetCost(aux.dxmcostgen(1,1))
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
    --Search
    local e3=bpev.toa_nuva_kaita_search(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCountLimit(1,id)
    c:RegisterEffect(e3)
end
function s.filter1(c)
    return c:IsLevel(8) and c:IsSetCard(0xb02)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(s.filter1,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    local rc=re:GetHandler()
    local relation=rc:IsRelateToEffect(re)
    if chk==0 then return rc:IsAbleToRemove(tp) or (not relation and Duel.IsPlayerCanRemove(tp)) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if relation then
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,rc:GetControler(),rc:GetLocation())
    else
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,rc:GetPreviousLocation())
    end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
    end
end