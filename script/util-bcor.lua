BCOR={}
bcor=BCOR
--Rahi
function BCOR.rahi_insect_spsum(baseC,pstg,psop)
    local function filter(c)
        return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xb06) and c:IsMonster() and c:IsAbleToRemoveAsCost()
    end
    local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
        local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
        Duel.Remove(g,POS_FACEUP,REASON_COST)
    end
    local function target(e,tp,eg,ep,ev,re,r,rp,chk)
        local c=e:GetHandler()
        if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
        if pstg then pstg(e,tp,eg,ep,ev,re,r,rp,chk) end -- target function for optional post-summon actions
    end
    local function operation(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
            if psop then psop(e,tp,eg,ep,ev,re,r,rp) end -- operation for optional post-summon actions
        end
    end

    local e=Effect.CreateEffect(baseC)
    e:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e:SetType(EFFECT_TYPE_QUICK_O)
    e:SetRange(LOCATION_HAND)
    e:SetCode(EVENT_FREE_CHAIN)
    e:SetCost(cost)
    e:SetTarget(target)
    e:SetOperation(operation)
    return e
end
function BCOR.check_rahi_marine_isabletopzone(c,tp)
    return Duel.CheckPendulumZones(tp) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function BCOR.operation_rahi_marine_return(c,tp,exstr,pzstr)
    local op=Duel.SelectEffect(tp,
        {c:IsAbleToExtra(),exstr},
        {bcor.check_rahi_marine_isabletopzone(c,tp),pzstr}
    )
    if op==1 then
        return (Duel.SendtoExtraP(c,nil,REASON_EFFECT)>0)
    elseif op==2 then
        return Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end
function BCOR.rahi_beast_granteff(baseC,ge,desc,desc2)
    local function condition_inherit(e,tp,eg,ep,ev,re,r,rp)
        return r==REASON_SYNCHRO and re:GetHandler():IsSetCard(0xb06)
    end
    local function operation_inherit(e,tp,eg,ep,ev,re,r,rp)
        local c=re:GetHandler()
        local e1=ge:Clone()
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1,true)
        if desc2 then
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetDescription(desc2)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e2,true)
        end
        if not c:IsType(TYPE_EFFECT) then
            local e3=Effect.CreateEffect(e:GetHandler())
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_ADD_TYPE)
            e3:SetValue(TYPE_EFFECT)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e3,true)
        end
    end
    local function condition(e,tp,eg,ep,ev,re,r,rp)
        return r==REASON_SYNCHRO
    end
    local function operation(e,tp,eg,ep,ev,re,r,rp)
        local c=re:GetHandler()
        local e1=ge:Clone()
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1,true)
        if desc then
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetDescription(desc)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e2,true)
        end
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_BE_MATERIAL)
        e3:SetCondition(condition_inherit)
        e3:SetOperation(operation_inherit)
        c:RegisterEffect(e3,true)
        if not c:IsType(TYPE_EFFECT) then
            local e4=Effect.CreateEffect(e:GetHandler())
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetCode(EFFECT_ADD_TYPE)
            e4:SetValue(TYPE_EFFECT)
            e4:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e4,true)
        end
    end

    local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EVENT_BE_MATERIAL)
	e:SetCondition(condition)
	e:SetOperation(operation)
	return e
end