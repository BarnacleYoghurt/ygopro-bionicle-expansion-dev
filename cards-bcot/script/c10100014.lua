--Wairuha, Toa Kaita of Wisdom
local s,id=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1b02),6,3)
	c:EnableReviveLimit()
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
  --Wisdom
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_REMOVE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_DETACH_MATERIAL)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
s.listed_series={0x1b02}
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
  e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 then
    local t
    if e:GetLabel()==0 then t=TYPE_MONSTER end
    if e:GetLabel()==1 then t=TYPE_SPELL end
    if e:GetLabel()==2 then t=TYPE_TRAP end
    
    local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
    local dg=Duel.GetDecktopGroup(1-tp,1)
    Duel.ConfirmCards(tp,hg)
    Duel.ConfirmDecktop(1-tp,1)
    
    local ct=Group.Merge(hg,dg):FilterCount(Card.IsType,nil,t)
    if ct>=1 then
      Duel.BreakEffect()
      Duel.Draw(tp,1,REASON_EFFECT)
    end
    if ct==2 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
      local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
      if g:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
      end
    end
  end
end
  