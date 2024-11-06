if not bcot then
    Duel.LoadScript("util-bcot.lua")
end
--Legendary Kanohi Vahi, Mask of Time
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
    --Only 1 "Vahi" Equip Spell
    c:SetUniqueOnField(1,0,s.filter0,LOCATION_SZONE)
    --Destroy if replaced
    local e1=bcot.kanohi_selfdestruct(c)
    c:RegisterEffect(e1)
    --Cannot attack
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_EQUIP)
	e2a:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2a)
    --Cannot activate
	local e2b=e2a:Clone()
    e2b:SetCode(EFFECT_CANNOT_TRIGGER)
    c:RegisterEffect(e2b)
    --Cannot target
	local e2c=e2a:Clone()
	e2c:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2c:SetValue(aux.tgoval)
	c:RegisterEffect(e2c)
    --To hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(bcot.greatkanohi_con)
    e3:SetTarget(s.target3)
    e3:SetOperation(s.operation3)
    e3:SetCountLimit(1)
    c:RegisterEffect(e3)
    --Break the Time
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCondition(s.condition4)
    e4:SetTarget(s.target4)
    e4:SetOperation(s.operation4)
    c:RegisterEffect(e4)
    local e4b=e4:Clone()
    e4b:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e4b)
end
function s.filter0(c)
    return c:IsSetCard(0xb0d) and c:IsEquipSpell()
end
function s.filter3(c)
    return c:IsSetCard(0xb0d) and not c:IsEquipSpell() and c:IsAbleToHand()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function s.condition4(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and e:GetHandler():IsReason(REASON_EFFECT)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
    local e_skip = function (p)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_SKIP_BP)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        if Duel.IsTurnPlayer(p) and Duel.IsBattlePhase() then
            e1:SetLabel(Duel.GetTurnCount())
            e1:SetCondition(function(e_) return Duel.GetTurnCount()~=e_:GetLabel() end)
            e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
        else
            e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
        end
        return e1
    end

    Duel.RegisterEffect(e_skip(tp),tp)
    Duel.RegisterEffect(e_skip(1-tp),1-tp)
end