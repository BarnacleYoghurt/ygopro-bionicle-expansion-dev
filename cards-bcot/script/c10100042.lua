if not bcot then
	dofile "expansions/util-bcot.lua"
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
  e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
  --Recycle
  local e3=bcot.kanohi_revive(c,10100019)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
    Duel.ConfirmCards(tp,g)
    local tc=g:GetFirst()
    if tc:GetAttack() < e:GetHandler():GetEquipTarget():GetAttack() then
      Duel.Damage(1-tp,math.floor(tc:GetAttack()/2), REASON_EFFECT)
    end
  end
end
