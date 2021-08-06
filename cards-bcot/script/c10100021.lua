--Turaga Nuju
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
	--Flip
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1)
  c:RegisterEffect(e1)
  --Protect
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_PHASE+PHASE_END)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
end
function s.filter0(c)
  return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WARRIOR)
end
function s.check0(g,lc)
  return g:IsExists(s.filter0,1,nil)
end
function s.filter1(c)
  return c:IsFaceup() and c:IsCanTurnSet()
end
function s.rescon1(sg,e,tp,mg)
  return sg:IsExists(Card.IsControler,1,nil,tp) and sg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon1,0) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,rg,2,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon1,1,tp,HINTMSG_POSCHANGE)
	if #g==2 then
		Duel.HintSelection(g,true)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
    for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3313)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
		end
	end
end
function s.filter2(c)
  return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_SZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g1=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil)
  e:SetLabelObject(g1:GetFirst())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_SZONE,0,1,1,nil)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local mtc=e:GetLabelObject() --Monster target
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local stc=g:GetFirst() --Spell/Trap target
  if mtc==stc then stc=g:GetNext() end
  
  mtc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,mtc:GetFieldID())
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e1:SetCondition(s.condition2_1)
  e1:SetValue(1)
  e1:SetLabelObject(mtc)
  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
  stc:RegisterEffect(e1)
end
function s.condition2_1(e)
  local mtc=e:GetLabelObject()
  return e:GetLabelObject():GetFlagEffectLabel(id)==mtc:GetFieldID()
end