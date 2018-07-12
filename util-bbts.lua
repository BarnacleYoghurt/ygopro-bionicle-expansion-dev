--Bohrok Va
BohrokVa={}
bv=BohrokVa

function BohrokVa.selfss(baseC,reqCode)
	local function filter(c)
		return c:IsFaceup() and c:IsCode(reqCode)
	end
	local function condition(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetCode(EFFECT_SPSUMMON_PROC)
	e:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e:SetRange(LOCATION_HAND)
	e:SetCondition(condition)
	e:SetValue(1)
	e:SetCountLimit(1,baseC:GetCode())
	return e
end

function BohrokVa.krana(baseC)
	function operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsPreviousLocation(LOCATION_ONFIELD) then
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_TOHAND)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetTarget(target_1)
			e1:SetOperation(operation_1)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
	function filter_1(c)
		return c:IsSetCard(0x15d) and c:IsFaceup() and c:IsAbleToHand()
	end
	function target_1(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(filter_1,tp,LOCATION_REMOVED,0,1,nil) end
		local g=Duel.GetMatchingGroup(filter_1,tp,LOCATION_REMOVED,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	function operation_1(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,filter_1,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EVENT_TO_GRAVE)
	e:SetOperation(operation)
	return e
end
--Bohrok Kaita
BohrokKaita={}
bk=BohrokKaita

function BohrokKaita.krana(baseC)
	function filter(c)
		return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15d) and c:IsAbleToGrave()
	end
	function condition(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then 
			return Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK,0,1,nil) 
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		end
		local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_DECK,0,1,3,nil)
		g:KeepAlive()
		e:SetLabelObject(g)
		e:SetLabel(g:Select(1-tp,1,1,nil):GetFirst():GetCode())
	end
	function operation(e,tp,eg,ep,ev,re,r,rp)
		local g=e:GetLabelObject()
		if g and g:FilterCount(Card.IsCode,nil,e:GetLabel())>0 then
			local c=e:GetHandler()
			local ec=g:Filter(Card.IsCode,nil,e:GetLabel()):GetFirst()
			Duel.Equip(tp,ec,c,true)
			g:RemoveCard(ec)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e:SetCode(EVENT_SPSUMMON_SUCCESS)
	e:SetCondition(condition)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end