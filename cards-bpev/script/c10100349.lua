--Bohrok-Kal Kaita Ja
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Material
	Fusion.AddProcCode3(c,10100332,10100335,10100336,true,true)
	Fusion.AddContactProc(c,s.contactgroup,s.contactop,s.contactsumcon)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,{id,1})
	c:RegisterEffect(e2)
end
function s.contactgroup(tp)
	return Duel.GetReleaseGroup(tp)
end
function s.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function s.contactsumcon(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.filter1a(c)
	return c:IsSetCard(0xb08) and c:IsAbleToRemoveAsCost()
end
function s.filter1b(c)
	return (c:IsLocation(LOCATION_MZONE) or c:IsMonster()) and not c:IsForbidden()
end
-- Because we can, in theory, target the same monsters that can be banished for cost, a special check is needed
-- A cost selection is valid iff it leaves a target available in the locations its size permits
function s.rescon1(sg,e,tp,mg)
	local range=LOCATION_GRAVE+(#sg>1 and LOCATION_MZONE or 0)
	return Duel.IsExistingTarget(s.filter1b,tp,range,range,1,sg+e:GetHandler())
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	local cg=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(cg,e,tp,1,3,s.rescon1,0,tp,0,s.rescon1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=aux.SelectUnselectGroup(cg,e,tp,1,3,s.rescon1,1,tp,HINTMSG_REMOVE,s.rescon1)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(ct)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local range=LOCATION_GRAVE+(e:GetLabel()>1 and LOCATION_MZONE or 0)
	if chkc then return s.filter1b(chkc) and chkc:IsLocation(range) and chkc~=c end
	if chk==0 then return true end -- Target availability is already checked in cost processing
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.filter1b,tp,range,range,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	if e:GetLabel()>=3 then
		Duel.SetChainLimit(function(e,ep,tp) return ep==tp end)
	end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:EquipByEffectAndLimitRegister(e,tp,tc,id) then
		local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
	end
end
function s.filter2(c,e,tp)
	return c:IsSetCard(0xb08) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.filter2(chkc,e,tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.Overlay(tc,e:GetHandler(),true)
	end
end