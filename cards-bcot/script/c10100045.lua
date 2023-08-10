if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Noble Kanohi Mahiki
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
	--Token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
  --Destroy Token
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(s.operation3)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Recycle
  local e4=bcot.kanohi_revive(c,10100022)
  e4:SetDescription(aux.Stringid(id,1))
  e4:SetCountLimit(1,id)
  c:RegisterEffect(e4)
end
s.listed_names={10100022,id+10000}
s.listed_series={0xb04,0xb03,0xb02,0xb07}
function s.condition2(e)
	local tp=e:GetHandlerPlayer()
  local ec=e:GetHandler():GetEquipTarget()
  local ct=1-math.abs(tp-ec:GetControler()) --1 if on own field, 0 if on opponent's
	return bcot.noblekanohi_con(e) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==ct
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+10000,0,0x4011,0,0,3,RACE_SPELLCASTER,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) then
    local token=Duel.CreateToken(tp,id+10000)
    if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
      e:SetLabelObject(token)
    end
  end
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end