--Turaga Vakama
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	aux.AddLinkProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
  --Vision
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Draw
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_BATTLE_DESTROYED)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id+1000000)
  c:RegisterEffect(e2)
end
function s.filter0(c)
  return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR)
end
function s.check0(g,lc)
  return g:IsExists(s.filter0,1,nil)
end
function s.filter1(c,e,tp)
  return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,tp,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  Duel.ConfirmDecktop(tp,1)
  Duel.ConfirmDecktop(1-tp,1)
	local sg=Duel.GetDecktopGroup(tp,1)
	local og=Duel.GetDecktopGroup(1-tp,1)
  
  local function condsummon(g,tgp)
    if g:IsExists(s.filter1,1,nil,e,tgp) then
      Duel.SpecialSummonStep(g:GetFirst(),SUMMON_TYPE_SPECIAL,tgp,tgp,false,false,POS_FACEUP)
    elseif Duel.IsPlayerCanSpecialSummonMonster(tgp,10110017,0,0x4011,1500,0,3,RACE_WARRIOR,ATTRIBUTE_FIRE) then
      local token=Duel.CreateToken(tgp,10110017)
      Duel.SpecialSummonStep(token,SUMMON_TYPE_SPECIAL,tgp,tgp,false,false,POS_FACEUP_ATTACK)
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UNRELEASABLE_SUM)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e1:SetValue(1)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD)
      token:RegisterEffect(e1,true)
      local e1a=e1:Clone()
      e1a:SetCode(EFFECT_UNRELEASABLE_NONSUM)
      token:RegisterEffect(e1a)
      local e2=e1:Clone()
      e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
      token:RegisterEffect(e2,true)
      local e3=e1:Clone()
      e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
      token:RegisterEffect(e3,true)
    end
  end
  
  --Summon FIRE Warrior or Token (self)
  condsummon(sg,tp)
  --Summon FIRE Warrior or Token (opponent)
  condsummon(og,1-tp)
  
  Duel.SpecialSummonComplete()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end