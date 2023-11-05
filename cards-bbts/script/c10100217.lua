if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Bohrok Gahlok Va
function s.initial_effect(c)
	--special summon
	local e1=bbts.bohrokva_selfss(c,10100202)
	c:RegisterEffect(e1)
	--Peek
	local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id+1000000)
	c:RegisterEffect(e2)
	--Return
	local e3=bbts.bohrokva_shuffle(c)
	c:RegisterEffect(e3)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:GetCount()>0 end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc:IsSetCard(0xb08) and tc:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		end
	end
end
