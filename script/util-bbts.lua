BBTS={}
bbts=BBTS
--Bohrok
function BBTS.bohrok_flip(baseC)
  local function filter(c,e,tp)
    return c:IsSetCard(0xb08) and c:GetLevel()==4 and not c:IsCode(baseC:GetOriginalCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
      return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK,0,1,nil,e,tp) 
    end
    local g=Duel.GetMatchingGroup(filter,tp,LOCATION_DECK,0,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
  end
  function operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount() > 0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
      Duel.ConfirmCards(1-tp,g)
    end
  end
  local e=Effect.CreateEffect(baseC)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e:SetDescription(aux.Stringid(baseC:GetOriginalCode(),0))
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
function BBTS.bohrok_shuffledelayed(baseC)
  local function condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetFlagEffectLabel(baseC:GetOriginalCode())==e:GetLabel()
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
  end
  local fid=baseC:GetFieldID()
  baseC:RegisterFlagEffect(baseC:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
  local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_TODECK)
  e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e:SetCode(EVENT_PHASE+PHASE_END)
  e:SetCondition(condition)
  e:SetOperation(operation)
  e:SetLabel(fid)
  e:SetCountLimit(1)
  e:SetReset(RESET_PHASE+PHASE_END)
	return e
end
--Krana
function BBTS.krana_equip(baseC)
	local function filter(c)
		return c:IsFaceup() and c:IsSetCard(0xb08) and c:IsLevelAbove(4)
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(filter,tp,LOCATION_MZONE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		Duel.SelectTarget(tp,filter,tp,LOCATION_MZONE,0,1,1,nil)
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local tc=Duel.GetFirstTarget()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or not filter(tc) or not tc:IsRelateToEffect(e) then
			Duel.SendtoGrave(c,REASON_EFFECT)
			return
		end
		Duel.Equip(tp,c,tc,true)
		
		local function value_1(e,c)
			return c==e:GetLabelObject()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(value_1)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	
	local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_EQUIP)
  e:SetDescription(aux.Stringid(baseC:GetOriginalCode(),0))
	e:SetType(EFFECT_TYPE_QUICK_O)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetRange(LOCATION_HAND)
	e:SetCode(EVENT_FREE_CHAIN)
	e:SetTarget(target)
	e:SetOperation(operation)
	e:SetCountLimit(1)
	return e
end
function BBTS.krana_revive(baseC,clienthint)
	local function condition(e,tp,eg,ep,ev,re,r,rp)
		local rc=nil
    if re then
      rc=re:GetHandler()
    elseif Duel.GetAttacker() then
      if Duel.GetAttacker():GetControler() == tp then
        rc=Duel.GetAttacker()
      elseif Duel.GetAttackTarget() then
        rc=Duel.GetAttackTarget()
      end
    end
    if eg:GetCount()~=1 then return false end
    local tc=eg:GetFirst()
    return tc:IsType(TYPE_MONSTER) and tc:IsLocation(LOCATION_GRAVE) and tc:GetPreviousControler()==1-tp and rc and rc:IsType(TYPE_MONSTER) and rc:IsSetCard(0xb08)
	end
	local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsAbleToRemoveAsCost() end
		Duel.Remove(c,POS_FACEUP,REASON_COST)
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		local tc=eg:GetFirst()
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
		Duel.SetTargetCard(tc)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	end
  local function target_1(e,c)
    local tp=e:GetHandlerPlayer()
    return c:IsLocation(LOCATION_GRAVE) and c:IsControler(1-tp)
  end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD)
      e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
      e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
      e1:SetTargetRange(1,0)
      e1:SetTarget(target_1)
      e1:SetReset(RESET_PHASE+PHASE_END)
      Duel.RegisterEffect(e1,tp)
      aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,clienthint,nil)
		end
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e:SetDescription(aux.Stringid(baseC:GetOriginalCode(),1))
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e:SetRange(LOCATION_GRAVE)
	e:SetCode(EVENT_DESTROYED)
	e:SetCondition(condition)
	e:SetCost(cost)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
function BBTS.krana_summon(baseC)
	local function filter(c,e,tp)
		return c:IsSetCard(0xb08) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
	end
	local function condition(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
	end
	local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
		Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
		local g=Duel.GetMatchingGroup(filter,tp,LOCATION_DECK,0,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount() > 0 then
			if Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP_ATTACK) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(3206)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        g:GetFirst():RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetDescription(3302)
        e2:SetCode(EFFECT_CANNOT_TRIGGER)
        g:GetFirst():RegisterEffect(e2)
			end
      Duel.SpecialSummonComplete()
		end
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e:SetDescription(aux.Stringid(baseC:GetOriginalCode(),1))
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetRange(LOCATION_MZONE)
	e:SetCondition(condition)
	e:SetCost(cost)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
function BBTS.krana_condition_equipped(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and tc:IsSetCard(0xb08)
end
--Bohrok Va
function BBTS.bohrokva_selfss(baseC,reqCode)
	local function filter(c)
		return c:IsFaceup() and c:IsCode(reqCode)
	end
	local function condition(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e:SetCode(EFFECT_SPSUMMON_PROC)
	e:SetRange(LOCATION_HAND)
	e:SetCondition(condition)
	e:SetValue(1)
	e:SetCountLimit(1,baseC:GetOriginalCode())
	return e
end

function BBTS.bohrokva_krana(baseC)
	local function filter_1(c)
		return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb09) and c:IsFaceup() and c:IsAbleToHand()
	end
	local function target_1(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(filter_1,tp,LOCATION_REMOVED,0,1,nil) end
		local g=Duel.GetMatchingGroup(filter_1,tp,LOCATION_REMOVED,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	local function operation_1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,filter_1,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsPreviousLocation(LOCATION_ONFIELD) then
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_TOHAND)
      e1:SetDescription(aux.Stringid(baseC:GetOriginalCode(),1))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetTarget(target_1)
			e1:SetOperation(operation_1)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EVENT_TO_GRAVE)
	e:SetOperation(operation)
	return e
end
function BBTS.bohrokva_shuffle(baseC)
	local function filter_1(c)
		return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb08) and c:IsAbleToDeck() and not c:IsCode(baseC:GetOriginalCode())
	end
	local function target_1(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(filter_1,tp,LOCATION_GRAVE,0,2,nil) and Duel.IsPlayerCanDraw(tp, 1) end
		local g=Duel.GetMatchingGroup(filter_1,tp,LOCATION_GRAVE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	local function operation_1(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(filter_1,tp,LOCATION_GRAVE,0,2,nil) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,filter_1,tp,LOCATION_GRAVE,0,2,2,nil)
		if g:GetCount()>1 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>1 then
      if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
      Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsPreviousLocation(LOCATION_ONFIELD) then
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
      e1:SetDescription(aux.Stringid(baseC:GetOriginalCode(),1))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetTarget(target_1)
			e1:SetOperation(operation_1)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EVENT_TO_GRAVE)
	e:SetOperation(operation)
	return e
end
--Bohrok Kaita
function BBTS.bohrokkaita_krana(baseC)
	local function filter(c)
		return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb09) and c:IsAbleToHand()
	end
	local function condition(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_DECK,0,1,3,nil)
		if g:GetCount()>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local ag=g:Select(1-tp,1,1,nil)
			if ag:GetCount()>0 then
        if Duel.SendtoHand(ag,nil,REASON_EFFECT)>0 then
          g:RemoveCard(ag:GetFirst())
        end
			end
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
	
	local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
  e:SetDescription(aux.Stringid(baseC:GetOriginalCode(),0))
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e:SetCode(EVENT_SPSUMMON_SUCCESS)
	e:SetCondition(condition)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
--Bohrok Va Kaita
function BBTS.bohrokvakaita_synchrolimit(baseC)	
	local e=Effect.CreateEffect(baseC)
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetCode(EFFECT_SYNCHRO_MAT_RESTRICTION)
	e:SetValue(aux.TargetBoolFunction(Card.IsSetCard,0xb08))
	return e
end
function BBTS.bohrokvakaita_switch(baseC)	
	local function filter(c,e,tp)
		return c:IsSetCard(0xb08) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	local function condition(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsReleasable() end
		Duel.Release(e:GetHandler(),REASON_COST)
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
		local g=Duel.GetMatchingGroup(filter,tp,LOCATION_EXTRA,0,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount() > 0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e:SetDescription(aux.Stringid(baseC:GetOriginalCode(),0))
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e:SetRange(LOCATION_MZONE)
	e:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e:SetCondition(condition)
	e:SetCost(cost)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
--Bahrag
function bbts.bahrag_pendset(baseC)
	function condition(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsFaceup() and tp==Duel.GetTurnPlayer()
	end
	function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	end
	function operation(e,tp,eg,ep,ev,re,r,rp)
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
	local e=Effect.CreateEffect(baseC)
  e:SetDescription(aux.Stringid(baseC:GetOriginalCode(),2))
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e:SetRange(LOCATION_EXTRA)
	e:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e:SetCondition(condition)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end