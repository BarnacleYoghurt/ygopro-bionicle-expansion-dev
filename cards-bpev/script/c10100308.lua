if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Toa Nuva Onua
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Material
	Fusion.AddProcMix(c,true,true,10100003,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb0b))
  --Add Spell/Trap
  local e1=bpev.toa_nuva_search(c)
  e1:SetDescription(aux.Stringid(id,0))
  c:RegisterEffect(e1)
  --To Deck
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetHintTiming(TIMING_MAIN_END)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
  c:RegisterEffect(e2)
end
s.material_setcode={0xb02,0xb0b}
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsMainPhase()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    local ct
    if tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0 then
			ct=Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		else
			ct=Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
		end
    if ct>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
      Duel.BreakEffect()
      Duel.Recover(tp,1000,REASON_EFFECT)
    end
  end
end
    
