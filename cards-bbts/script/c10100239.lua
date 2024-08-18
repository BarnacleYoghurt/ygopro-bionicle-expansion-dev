--Hapaka, Shepherd Rahi
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--DEF gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xb06))
	e1:SetValue(700)
	--c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
	--Block destruction
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(s.target3)
	e3:SetValue(s.value3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1,{id,1})
	c:RegisterEffect(e3)
	--To Grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation4)
	e4:SetCountLimit(1,{id,2})
	c:RegisterEffect(e4)
end
function s.filter2a(c,e,tp)
	local hg=e:GetHandler()+Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if c:IsAbleToHandAsCost() then hg=c+hg end --c will be in hand after bounce
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsRace(RACE_BEAST|RACE_WINGEDBEAST) and c:IsSetCard(0xb06)
		and c:IsAbleToHand() and hg:IsExists(s.filter2b,1,nil,e,tp) and Duel.GetMZoneCount(tp,c)>0
end
function s.filter2b(c,e,tp)
	local sumchk=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if c:IsLocation(LOCATION_MZONE) then --not registered as summonable while still on the field!
		--documentation says you could just pass the id, but in-game error says otherwise ...
		--sumchk=Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode())
		sumchk=Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),c:GetOriginalSetCard(),c:GetOriginalType(),
			c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
	end
	return c:IsLevelBelow(4) and c:IsSetCard(0xb06) and sumchk
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return s.filter2(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter2a,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.filter2a,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c+g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g1=Group.FromCards(c,tc)
		if Duel.SendtoHand(g1,nil,REASON_EFFECT)==2 and g1:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==2
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if #g2>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end
	end
end
function s.filter3(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_BEAST|RACE_WINGEDBEAST) and c:IsSetCard(0xb06)
		and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and eg:IsExists(s.filter3,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.value3(e,c)
	return s.filter3(c,e:GetHandlerPlayer())
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
function s.filter4(c)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_REMOVED)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end