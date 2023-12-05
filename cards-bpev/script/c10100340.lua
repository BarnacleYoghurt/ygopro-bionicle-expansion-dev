if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Krana Ca-Kal, Seeker
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
    --Xyz Summon
    local e2=bpev.krana_kal_xsummon(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCountLimit(1)
    c:RegisterEffect(e2)
    --Battle protection 
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_XMATERIAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetCondition(s.make_condition(1))
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --Draw
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
    e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(s.make_condition(2))
    e4:SetTarget(s.target4)
    e4:SetOperation(s.operation4)
    e4:SetCountLimit(1)
    c:RegisterEffect(e4)
end
function s.filter0(c)
  return c:IsSetCard(0xb08) or c:IsSetCard(0xb09)
end
function s.filter(c)
    return c:IsSetCard(0xb0a) and c:IsOriginalType(TYPE_MONSTER) and c:IsFaceup()
end
function s.make_condition(ct)
    return function(e)
        return e:GetHandler():IsSetCard(0xb08) and Duel.GetMatchingGroup(s.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_REMOVED,0,nil):GetClassCount(Card.GetCode)>=ct
    end
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end