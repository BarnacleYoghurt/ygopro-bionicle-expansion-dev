--Wairuha, Toa Kaita of Wisdom
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb02),6,3)
	c:EnableReviveLimit()
	--Wisdom (Negate)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100014,1))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
  return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp and Duel.IsChainNegatable(ev)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
  e:SetLabel(Duel.SelectOption(tp,70,71,72))
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 then
    local t
    if e:GetLabel()==0 then t=TYPE_MONSTER end
    if e:GetLabel()==1 then t=TYPE_SPELL end
    if e:GetLabel()==2 then t=TYPE_TRAP end
    
    local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
    local dg=Duel.GetDecktopGroup(1-tp,1)
    Duel.ConfirmCards(tp,hg)
    Duel.ConfirmDecktop(1-tp,1)
    Duel.BreakEffect()
    
    local ct=Group.Merge(hg,dg):FilterCount(Card.IsType,nil,t)
    if ct>=1 then
      Duel.Draw(tp,1,REASON_EFFECT)
    end
    if ct==2 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
      local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
      if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
      end
    end
  end
end