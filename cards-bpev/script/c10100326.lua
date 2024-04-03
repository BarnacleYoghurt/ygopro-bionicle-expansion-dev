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
    --Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.IsMainPhase() end)
    e2:SetCost(s.cost2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
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
function s.filter2(c,e,tp)
    return c:IsLevel(8) and c:IsSetCard(0xb02) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.SetTargetParam(e:GetHandler():GetOverlayCount())
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():GetOverlayCount()>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local ct=math.min(Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM),Duel.GetLocationCount(tp,LOCATION_MZONE))
    local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
    local g=Duel.GetTargetCards(e)
    if g:GetCount()==0 then return end
    if g:GetCount()>ft then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      g=g:Select(tp,ft,ft,nil)
    end
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
