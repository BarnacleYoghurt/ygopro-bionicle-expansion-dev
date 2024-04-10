if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Akamai, Toa Nuva Kaita of Valor
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    c:SetSPSummonOnce(id)
    --Xyz Material
    Xyz.AddProcedure(c,nil,8,3)
    --Cannot activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_MATERIAL_CHECK)
    e0:SetValue(s.value0)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.condition1)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
    e0:SetLabelObject(e1)
    --Destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCost(aux.dxmcostgen(1,1))
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    c:RegisterEffect(e2)
    --Search
    local e3=bpev.toa_nuva_kaita_search(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCountLimit(1,id)
    c:RegisterEffect(e3)
end
function s.filter0(c)
    return c:IsLevel(8) and c:IsSetCard(0xb02)
end
function s.value0(e,c)
    local g=c:GetMaterial()
	if g:IsExists(s.filter0,1,nil) then
		e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
	end
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.GetTurnPlayer()==tp and e:GetLabel()==1
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
	e2:SetTargetRange(0,1)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsSpellTrap() and chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.SelectTarget(tp,Card.IsSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end