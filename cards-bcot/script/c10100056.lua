if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Copper Kanohi of Victory
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_START)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
  --Equip to highest ATK
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ec:IsSetCard(0xb01) or ec:IsSetCard(0xb02) or ec:IsSetCard(0xb03)) and (Duel.GetAttacker()==ec or Duel.GetAttackTarget()==ec)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) end
	local g=Group.FromCards(tc,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:GetEquipTarget():GetBattleTarget():IsRelateToBattle() then
    Duel.Destroy(Group.FromCards(c:GetEquipTarget():GetBattleTarget(),c),REASON_EFFECT)
  end
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:CheckUniqueOnField(tp)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chk==0 then return c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
  tg=tg:GetMaxGroup(Card.GetAttack)
	if c:IsRelateToEffect(e) and c:CheckUniqueOnField(tp) then
    if tg:GetCount()>1 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			tg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
    end
    if tg:GetCount()>0 and Duel.Equip(tp,c,tg:GetFirst()) then
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(3300)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
      e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
      e1:SetValue(LOCATION_REMOVED)
      c:RegisterEffect(e1,true)
    end
	end
end