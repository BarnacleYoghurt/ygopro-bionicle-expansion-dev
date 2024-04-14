if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Wairuha, Toa Nuva Kaita of Wisdom
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Xyz Material
    Xyz.AddProcedure(c,nil,8,3)
    --Negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition1)
	e1:SetCost(aux.dxmcostgen(1,1))
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
    --Search
    local e2=bpev.toa_nuva_kaita_search(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
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
    if rc:IsRelateToEffect(re) then
        Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,rc,1,rc:GetControler(),rc:GetLocation())
    else
        Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,0,0,rc:GetPreviousLocation())
    end
    Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
    Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
    Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    local odc=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,1-tp,LOCATION_DECK,0,nil,tp)
    local pdc=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil,tp)
    if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and rc:IsAbleToRemove(tp) and odc+pdc>0 then
        local op=Duel.SelectEffect(tp,{odc>0,aux.Stringid(id,2)},{pdc>0,aux.Stringid(id,3)},{true,aux.Stringid(id,4)})
        local rg
        if op==1 then
            rg=eg+Duel.GetDecktopGroup(1-tp,1)
        elseif op==2 then
            rg=eg+Duel.GetDecktopGroup(tp,1)
        end
        if rg then
            Duel.DisableShuffleCheck()
            if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)==2
                and rg:GetClassCount(function (c) return c:GetType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP) end)==2 then
                Duel.BreakEffect()
                Duel.Draw(tp,1,REASON_EFFECT)
            end
        end
    end
end