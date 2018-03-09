--Circle of Legends, Amaja-Nui
function c10100060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Detune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100060,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10100060.target2)
	e2:SetOperation(c10100060.operation2)
	e2:SetCountLimit(1,10100060)
	c:RegisterEffect(e2)
	--Change Level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100060,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c10100060.target3)
	e3:SetOperation(c10100060.operation3)
	e3:SetCountLimit(1,11100060)
	c:RegisterEffect(e3)
	--Revive
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100060,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10100060.condition4)
	e4:SetTarget(c10100060.target4)
	e4:SetOperation(c10100060.operation4)
	e4:SetCountLimit(1,12100060)
	c:RegisterEffect(e4)
	--Synchro from beyond the grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10100060,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c10100060.condition5)
	e5:SetTarget(c10100060.target5)
	e5:SetOperation(c10100060.operation5)
	c:RegisterEffect(e5)
end
--e2 - Detune
function c10100060.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsSetCard(0x156)
end
function c10100060.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10100060.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10100060.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10100060.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10100060.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetType()-TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
--e3 - Change Level
function c10100060.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsLevelAbove(1)
end
function c10100060.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10100060.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10100060.filter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10100060.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(10100060,4))
	else op=Duel.SelectOption(tp,aux.Stringid(10100060,4),aux.Stringid(10100060,5)) end
	e:SetLabel(op)
end
function c10100060.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end
--e4 - Revive
function c10100060.filter4(c,e,tp)
	return c:IsSetCard(0x156) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100060.condition4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c10100060.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100060.filter4,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10100060.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100060.filter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e5 - Synchro from beyond the Grave
function c10100060.filter5a(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x156) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100060.filter5b(c,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100060.filter5c(c,e,tp,ntg)
	local combo=false
	if ntg and ntg:GetCount()>0 then
		local tc=ntg:GetFirst()
		while tc and not combo do
			combo=Duel.IsExistingMatchingCard(c10100060.filter5e,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,tc))
			tc=ntg:GetNext()
		end
	end
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x156) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and combo
end
function c10100060.filter5d(c,e,tp,tg)
	local combo=false
	if tg and tg:GetCount()>0 then
		local tc=tg:GetFirst()
		while tc and not combo do
			combo=Duel.IsExistingMatchingCard(c10100060.filter5e,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,tc))
			tc=tg:GetNext()
		end
	end
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and combo
end
function c10100060.filter5e(c,mg)
	if mg:GetFirst():IsLocation(LOCATION_GRAVE) then return true end
	return c:IsSynchroSummonable(nil,mg)
end
function c10100060.condition5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD)~=0 and c:IsPreviousPosition(POS_FACEUP) and rp~=tp
end
function c10100060.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonCount(tp,2)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c10100060.filter5c,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetMatchingGroup(c10100060.filter5b,tp,LOCATION_GRAVE,0,nil,e,tp)) 
			and Duel.IsExistingTarget(c10100060.filter5d,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetMatchingGroup(c10100060.filter5a,tp,LOCATION_GRAVE,0,nil,e,tp)) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g=Duel.SelectTarget(tp,c10100060.filter5c,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,Duel.GetMatchingGroup(c10100060.filter5b,tp,LOCATION_GRAVE,0,nil,e,tp))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	Duel.SelectTarget(tp,c10100060.filter5d,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10100060.operation5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(c10100060.filter5e,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end