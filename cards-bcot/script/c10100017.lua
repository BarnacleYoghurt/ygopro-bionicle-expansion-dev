--Turaga Vakama
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,nil,2,2,s.check0)
	c:EnableReviveLimit()
  --Vision
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
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
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_BATTLE_DESTROYED)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,{id,1})
  c:RegisterEffect(e2)
end
s.listed_names={id+10000}
function s.filter0(c)
  return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR)
end
function s.check0(g,lc)
  return g:IsExists(s.filter0,1,nil)
end
function s.filter1(c)
  return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR) 
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<=0 then return end
  
  Duel.ConfirmDecktop(tp,1)
  Duel.ConfirmDecktop(1-tp,1)
	local sg=Duel.GetDecktopGroup(tp,1)
	local og=Duel.GetDecktopGroup(1-tp,1)

  local function condsummon(tc,tgp)
    if Duel.GetLocationCount(tgp,LOCATION_MZONE)<=0 then return false end
    if s.filter1(tc) then
      if tc:IsCanBeSpecialSummoned(e,tgp,tgp,false,false) then
        Duel.SpecialSummonStep(tc,SUMMON_TYPE_SPECIAL,tgp,tgp,false,false,POS_FACEUP)
        return true
      end
    elseif Duel.IsPlayerCanSpecialSummonMonster(tgp,id+10000,0,TYPES_TOKEN,1500,0,3,RACE_WARRIOR,ATTRIBUTE_FIRE) then
      local token=Duel.CreateToken(tgp,id+10000)
      Duel.SpecialSummonStep(token,SUMMON_TYPE_SPECIAL,tgp,tgp,false,false,POS_FACEUP_ATTACK)
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetDescription(3303)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
      e1:SetCode(EFFECT_UNRELEASABLE_SUM)
      e1:SetValue(1)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD)
      token:RegisterEffect(e1,true)
      local e1a=e1:Clone()
      e1a:SetCode(EFFECT_UNRELEASABLE_NONSUM)
      token:RegisterEffect(e1a)
      local e2=e1:Clone()
      e2:SetDescription(3310)
      e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
      token:RegisterEffect(e2,true)
      local e3=e1:Clone()
      e3:SetDescription(3312)
      e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
      token:RegisterEffect(e3,true)
      return true
    end
    return false
  end
  
  --Summon FIRE Warrior or Token (self)
  local s1=condsummon(sg:GetFirst(),tp)
  --Summon FIRE Warrior or Token (opponent)
  local s2=condsummon(og:GetFirst(),1-tp)
  
  if s1 or s2 then --Complete SS if any happened
    Duel.SpecialSummonComplete()
  end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end