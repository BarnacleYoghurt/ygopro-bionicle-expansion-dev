if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Great Kanohi Akaku
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Hand Reveal
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	e2:SetCode(EFFECT_PUBLIC)
  e2:SetCondition(s.condition)
	c:RegisterEffect(e2)
	--Banish Spell/Trap
	local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_TO_HAND)
  e3:SetCondition(s.condition)
  e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
  e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	--Search
  local e4=bcot.kanohi_search(c,10100005)
  e4:SetDescription(aux.Stringid(id,1))
  e4:SetCountLimit(1,id)
	c:RegisterEffect(e4)
end
s.listed_names={10100005}
s.listed_series={0xb04,0xb02,0xb07}
function s.condition(e)
  local ec=e:GetHandler():GetEquipTarget()
	return bcot.greatkanohi_con(e) and ec:IsControler(e:GetOwnerPlayer())
end
function s.filter3(c,tp)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsControler(1-tp) and c:IsAbleToRemove()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(s.filter3,1,nil,tp) end
  Duel.SetTargetCard(eg)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:FilterCount(s.filter3,nil,tp),0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local rg=eg:Filter(s.filter3,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
  if e:GetHandler():IsRelateToEffect(e) and rg:GetCount()>0 then
    Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
    local tc=rg:GetFirst()
    for tc in aux.Next(rg) do
      tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
    end
    rg:KeepAlive()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCondition(s.condition3_1)
    e1:SetOperation(s.operation3_1)
    e1:SetLabelObject(rg)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
  end
end
function s.filter3_1(c)
  return c:GetFlagEffect(id)~=0
end
function s.condition3_1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(s.filter3_1,nil,id)
	if g:GetCount()==0 then
		e:Reset()
		return false
	else
		return true
	end
end
function s.operation3_1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(s.filter3_1,nil,id)
	Duel.SendtoHand(g,1-tp,REASON_EFFECT)
end