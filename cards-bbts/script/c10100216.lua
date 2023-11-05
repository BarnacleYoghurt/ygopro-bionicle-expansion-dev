if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Bohrok Tahnok Va
function s.initial_effect(c)
	--special summon
	local e1=bbts.bohrokva_selfss(c,10100201)
	c:RegisterEffect(e1)
	--Increase Level
	local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_REMOVE+CATEGORY_LVCHANGE)
  e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Return
	local e3=bbts.bohrokva_krana(c)
	c:RegisterEffect(e3)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=2 then return end
	local c=e:GetHandler()
  Duel.ConfirmDecktop(tp, 3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local bg = g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
		if bg:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.Remove(bg,POS_FACEUP,REASON_EFFECT)
			local tc = bg:GetFirst()
			if tc:IsSetCard(0xb08) and tc:HasLevel() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(tc:GetLevel())
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD_DISABLE)
				c:RegisterEffect(e1)
			end
		end
	end
end