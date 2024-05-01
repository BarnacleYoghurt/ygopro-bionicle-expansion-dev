if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Akamai, Toa Nuva Kaita of Valor
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
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
    --Search
    local e2=bpev.toa_nuva_kaita_search(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
function s.filter0(c)
    return c:IsSetCard(0xb02) and c:IsType(TYPE_MONSTER)
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
	e1:SetValue(s.value1_1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
	e2:SetTargetRange(0,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.value1_1(e)
    return not (Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.GetCurrentPhase()==PHASE_END)
end