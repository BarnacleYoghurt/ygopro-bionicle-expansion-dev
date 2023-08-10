if not bcot then
	Duel.LoadScript("util-bcot.lua")
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
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_BATTLE_START)
  e2:SetCondition(s.condition2)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  c:RegisterEffect(e2)
  --Equip to highest ATK
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
s.listed_series={0xb04,0xb01,0xb03,0xb02}
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ec:IsSetCard(0xb01) or ec:IsSetCard(0xb02) or ec:IsSetCard(0xb03)) and ec:GetBattleTarget()
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
  local tc=c:GetEquipTarget():GetBattleTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToBattle() then
    Duel.Destroy(Group.FromCards(c:GetEquipTarget():GetBattleTarget(),c),REASON_EFFECT)
  end
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
  tg=tg:GetMaxGroup(Card.GetAttack)
	if c:IsRelateToEffect(e) then
    if tg:GetCount()>1 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			tg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
    end
    if tg:GetCount()>0 and Duel.Equip(tp,c,tg:GetFirst()) then
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(3300)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
      e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
      e1:SetValue(LOCATION_REMOVED)
      e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
      c:RegisterEffect(e1,true)
    end
	end
end