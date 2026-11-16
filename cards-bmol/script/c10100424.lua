--Matoran Hermit Kantai
local s,id=GetID()
function s.initial_effect(c)
    --Activate the turn it was Set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetCondition(s.condition0)
	c:RegisterEffect(e0)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
    local attr=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_ATTRIBUTE)
    return not (re:IsMonsterEffect() and attr~=ATTRIBUTE_WATER)
end
function s.condition0(e)
    return Duel.GetCustomActivityCount(id,e:GetHandlerPlayer(),ACTIVITY_CHAIN)==0
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
           and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT,1000,2000,4,RACE_WARRIOR,ATTRIBUTE_WATER)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and s.target1(e,tp,eg,ep,ev,re,r,rp,0) then
        c:AddMonsterAttribute(TYPE_EFFECT|TYPE_TRAP)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
        --Negate first Spell/Trap activated by opponent
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAIN_SOLVING)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCondition(s.condition1_1)
        e1:SetOperation(s.operation1_1)
        e1:SetCountLimit(1)
        e1:SetReset(RESET_EVENT|RESETS_STANDARD)
        c:RegisterEffect(e1,true)
        c:AddMonsterAttributeComplete()
    end
    Duel.SpecialSummonComplete()
end
function s.filter1_1(c)
    return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_WATER)
end
function s.condition1_1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.filter1_1,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsSpellTrapEffect() and Duel.IsChainDisablable(ev)
end
function s.operation1_1(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end