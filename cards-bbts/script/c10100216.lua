if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Tahnok Va
function c10100216.initial_effect(c)
	--special summon
	local e1=bbts.bohrokva_selfss(c,10100201)
	c:RegisterEffect(e1)
	--Increase Level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10100216.target2)
	e2:SetOperation(c10100216.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Return
	local e3=bbts.bohrokva_krana(c)
	c:RegisterEffect(e3)
end
function c10100216.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c10100216.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		local bg = g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
		if bg:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.Remove(bg,POS_FACEUP,REASON_EFFECT)
			local tc = bg:GetFirst()
			if tc:IsSetCard(0x15c) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e1:SetValue(tc:GetLevel())
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1ff0000)
				c:RegisterEffect(e1)
			end
		end
	end
end