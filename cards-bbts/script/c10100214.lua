if not bbts then
	Duel.LoadScript("util-bbts.lua")
end
local s,id=GetID()
--Krana Bo, Sentinel
function s.initial_effect(c)
	--Banish in the dark
	local e1a=Effect.CreateEffect(c)
  e1a:SetCategory(CATEGORY_REMOVE)
  e1a:SetDescription(aux.Stringid(id,0))
	e1a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1a:SetRange(LOCATION_HAND)
	e1a:SetCode(EVENT_DESTROYED)
	e1a:SetCondition(s.condition1)
	e1a:SetCost(s.cost1)
	e1a:SetTarget(s.target1)
	e1a:SetOperation(s.operation1)
	e1a:SetCountLimit(1,id)
	c:RegisterEffect(e1a)
  local e1b=e1a:Clone()
  e1b:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e1b)
	--Revive
	local e2=bbts.krana_revive(c,aux.Stringid(id,2))
	c:RegisterEffect(e2)
end
function s.filter1(c,ec)
  return c:IsCode(ec:GetCode()) and c:IsAbleToRemove()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xb08) and eg:GetCount()==1
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
  Duel.SendtoGrave(c,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
  local tg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  Duel.ConfirmCards(tp,tg)
  tg=tg:Filter(s.filter1,nil,ec)
  if tg:GetCount()>0 then
    Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
  end
end
