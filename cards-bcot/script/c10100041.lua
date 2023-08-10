if not bcot then
	Duel.LoadScript("util-bcot.lua")
end
--Noble Kanohi Rau
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Translate 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
  e2:SetCondition(s.condition2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
  --Recycle
  local e3=bcot.kanohi_revive(c,10100018)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
s.listed_names={10100018}
s.listed_series={0xb04,0xb03,0xb02,0xb07}
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
  if not bcot.noblekanohi_con(e) then return false end
  local ec=e:GetHandler():GetEquipTarget()
  local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsActivated() and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg and tg:IsContains(ec)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.operation2_1)
end
function s.filter2_1(c)
  return c:GetSequence()<5 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,LOCATION_REASON_CONTROL)>0
end
function s.operation2_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
  local function selectMove(mp)    
    if not Duel.IsExistingMatchingCard(s.filter2_1,mp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then return end
    if not Duel.SelectYesNo(mp,aux.Stringid(id,1)) then return end
    local g=Duel.SelectMatchingCard(mp,s.filter2_1,mp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
      local tc=g:GetFirst()
      Duel.Hint(HINT_SELECTMSG,mp,HINTMSG_TOZONE)
      local s, nseq
      if tc:IsControler(mp) then
        s=Duel.SelectDisableField(mp,1,LOCATION_MZONE,0,0)
        nseq=math.log(s,2)
      else
        s=Duel.SelectDisableField(mp,1,0,LOCATION_MZONE,0)
        nseq=math.log(s,2)-16
      end
      return tc, nseq
    end
  end
  
  local tc1,seq1=selectMove(tp)
  local moved1=false
  if tc1 and seq1 then
    Duel.MoveSequence(tc1,seq1)
    moved1=true
  end
  
  local tc2,seq2=selectMove(1-tp)
  if tc2 and seq2 then
    if moved1 then Duel.BreakEffect() end
    Duel.MoveSequence(tc2,seq2)
  end
end