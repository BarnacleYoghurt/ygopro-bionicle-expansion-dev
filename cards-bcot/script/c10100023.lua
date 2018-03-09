--The Island of Mata Nui
function c10100023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Substitute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100023,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10100023.target2)
	e2:SetValue(c10100023.value2)
	e2:SetOperation(c10100023.operation2)
	c:RegisterEffect(e2)
	--To Grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100023,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c10100023.condition3)
	e3:SetTarget(c10100023.target3)
	e3:SetOperation(c10100023.operation3)
	e3:SetCountLimit(1,10100023)
	c:RegisterEffect(e3)
	--Summon Restrict
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100023,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10100023.condition4)
	e4:SetOperation(c10100023.operation4)
	c:RegisterEffect(e4)
end
--e2 - Substitute
function c10100023.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1155) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c10100023.value2(e,c)
	return c10100023.filter2(c,e:GetHandlerPlayer())
end
function c10100023.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10100023.filter2,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(10100023,3))
end
function c10100023.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
--e3 - To Grave
function c10100023.filter3(c)
	return (c:IsType(TYPE_FIELD) and c:IsSetCard(0x159)) or c:IsCode(10100024) or c:IsCode(10100060)
end
function c10100023.condition3(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10100023.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100023.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100023.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100023.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e4 - Summon Restrict
function c10100023.condition4(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:GetFirst() and eg:GetFirst():GetLevel()>=6
end
function c10100023.operation4(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c10100023.target4_1)
	e1:SetLabel(eg:GetFirst():GetAttribute())
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c10100023.target4_1(e,c)
	return c:GetAttribute()~=e:GetLabel()
end