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
    --Look
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.condition2)
	e2:SetCost(aux.dxmcostgen(1,1))
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,{id,1})
	c:RegisterEffect(e2)
    --Search
    local e3=bpev.toa_nuva_kaita_search(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCountLimit(1,{id,2})
    c:RegisterEffect(e3)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    s.operation1_look(tp,tp)
    s.operation1_look(tp,1-tp)
end
function s.operation1_look(tp,p)
    local gc=math.min(5,Duel.GetFieldGroupCount(p,LOCATION_DECK,0))
	if gc>0 then
		local ac=gc==1 and gc or Duel.AnnounceNumberRange(tp,1,gc)
		Duel.ConfirmCards(tp,Duel.GetDecktopGroup(p,ac))
	end
end
function s.filter2(c)
    return c:IsLevel(8) and c:IsSetCard(0xb02)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(s.filter2,1,nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
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
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
    end
end