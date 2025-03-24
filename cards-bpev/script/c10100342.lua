if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Krana Ja-Kal, Tracker
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
	--Special Summon
	local e2=bpev.krana_kal_ssummon(c)
	e2:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e2)
	--Scout
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
s.listed_series={0xb08,0xb09}
function s.filter0(c)
	return c:IsSetCard(0xb08) or c:IsSetCard(0xb09)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0xb08)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTarget(s.target3_1)
	e1:SetValue(s.value3_1)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function s.target3_1(e,c)
	return c:IsFacedown() or (c:IsFaceup() and c:IsSetCard(0xb08))
end
function s.value3_1(e,re,tp)
	return re:GetHandler():IsOriginalCode(e:GetLabel())
end