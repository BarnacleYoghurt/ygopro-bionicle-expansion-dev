if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Krana Yo-Kal, Excavator
local s,id=GetID()
function s.initial_effect(c)
    --Link Summon
    Link.AddProcedure(c,s.filter0,1,1)
    c:EnableReviveLimit()
    --No Link Material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --ATK/DEF to 0
    local e2a,e2b,e2c=bpev.krana_kal_debuff(c,aux.Stringid(id, 0))
    c:RegisterEffect(e2a)
    c:RegisterEffect(e2b)
    c:RegisterEffect(e2c)
    --Direct attack
    local e3a=Effect.CreateEffect(c)
    e3a:SetType(EFFECT_TYPE_XMATERIAL)
    e3a:SetRange(LOCATION_MZONE)
    e3a:SetCode(EFFECT_DIRECT_ATTACK)
    e3a:SetCondition(s.condition3)
    c:RegisterEffect(e3a)
    --Block activations
    local e3b=Effect.CreateEffect(c)
	e3b:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e3b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3b:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3b:SetRange(LOCATION_MZONE)
	e3b:SetTargetRange(0,1)
	e3b:SetValue(1)
	e3b:SetCondition(aux.AND(s.condition3, function(e) return Duel.GetAttacker()==e:GetHandler() end))
	c:RegisterEffect(e3b)
end
function s.filter0(c)
    return c:IsSetCard(0xb08) or c:IsSetCard(0xb09)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSetCard(0xb08)
end