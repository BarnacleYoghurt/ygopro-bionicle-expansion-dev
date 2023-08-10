if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Noble Kanohi Ruru
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Confirm
	local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(bcot.noblekanohi_con)
  e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
  --Recycle
  local e3=bcot.kanohi_revive(c,10100019)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCountLimit(1,{id,1})
  c:RegisterEffect(e3)
end
s.listed_names={10100019}
s.listed_series={0xb04,0xb03,0xb02,0xb07}
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsFacedown() and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
  local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
  local ec=e:GetHandler():GetEquipTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFacedown() then
    Duel.ConfirmCards(tp,tc)
    if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
      Duel.Damage(1-tp,500,REASON_EFFECT)
    elseif tc:GetAttack() < ec:GetAttack() then
      Duel.Damage(1-tp,ec:GetAttack()-tc:GetAttack(), REASON_EFFECT)
    end
  end
end
