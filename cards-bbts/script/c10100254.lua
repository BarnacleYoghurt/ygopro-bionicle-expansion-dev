--Toa Seal
local s,id=GetID()
function s.initial_effect(c)
  --Seal
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_REMOVE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
end
function s.filter1a(c,e)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb02) and c:IsCanBeEffectTarget(e)
end
function s.filter1b(c)
  return c:IsLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  local g1=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_MZONE,0,nil,e)
  local g2=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil,e):Filter(Card.IsAbleToRemove,nil)
  if chk==0 then
    return g2:GetClassCount(Card.GetCode)>=6 
      and g1:GetCount()>0
      and (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
        or (g1:IsExists(s.filter1b,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)))
  end
  local tg=Group.CreateGroup()
	for i=1,6 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tgi
    if i==1 then
      tgi=g1:Select(tp,1,1,nil)
    else
      tgi=g2:Select(tp,1,1,nil)
    end
		g1:Remove(Card.IsCode,nil,tgi:GetFirst():GetCode())
		g2:Remove(Card.IsCode,nil,tgi:GetFirst():GetCode())
		tg:Merge(tgi)
	end
  Duel.SetTargetCard(tg)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE),0,0)
  
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,6,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local bg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_GRAVE)
  local fgc=tg:FilterCount(s.filter1b,nil,LOCATION_MZONE)
  
  if Duel.Remove(bg,POS_FACEUP,REASON_EFFECT)==bg:GetCount() then
    local handc=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    local handgc=0
    if math.min(fgc,handc)>0 then
      local sel=((not Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)) or Duel.SelectYesNo(tp,aux.Stringid(id,0)))
      if sel then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
        if math.min(fgc,handc)==1 then
          handgc=1
        elseif math.min(fgc,handc)==2 then
          handgc=Duel.AnnounceNumber(tp,1,2)
        elseif math.min(fgc,handc)==3 then
          handgc=Duel.AnnounceNumber(tp,1,2,3)
        elseif math.min(fgc,handc)==4 then
          handgc=Duel.AnnounceNumber(tp,1,2,3,4)
        elseif math.min(fgc,handc)==5 then
          handgc=Duel.AnnounceNumber(tp,1,2,3,4,5)
        elseif math.min(fgc,handc)==6 then
          handgc=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
        end
      end
    end
    local g=Group.CreateGroup()
    if handgc < 6 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then
      local sel=(math.min(fgc,handc)==0 or Duel.SelectYesNo(tp,aux.Stringid(id,2)))
      if sel then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,6-handgc,nil)
      end
    end
    if handgc>0 then
      g:Merge(Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,handgc))
    end
    
    if g:GetCount()>0 then
      Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
  end
end