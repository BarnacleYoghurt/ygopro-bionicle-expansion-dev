if not bbts_bk then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Kaita Za
function c10100228.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCode3(c,10100201,10100203,10100204,true,true)
	c:EnableReviveLimit()
	--Equip Krana
	local e1=bbts_bk.krana(c)
	c:RegisterEffect(e1)
	--Gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c10100228.target2)
	e2:SetOperation(c10100228.operation2)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=bbts_bk.ss(c)
	c:RegisterEffect(e3)
end
function c10100228.filter2(c)
	return c:IsSetCard(0x15c) and c:IsFaceup()
end
function c10100228.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c10100228.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
	end
	Duel.SelectTarget(tp,c10100228.filter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c10100228.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end