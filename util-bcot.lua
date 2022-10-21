BCOT={}
bcot=BCOT
--Toa Mata
function BCOT.toa_mata_tribute(baseC)
  --Based on True Draco
  --I have literally no idea what half of these functions are for
  local function val_multitribute(c,sc,ma)
    local eff3={c:GetCardEffect(EFFECT_TRIPLE_TRIBUTE)}
    if ma>=3 then
      for _,te in ipairs(eff3) do
        if te:GetValue()(te,sc) then return 0x30001 end
      end
    end
    local eff2={c:GetCardEffect(EFFECT_DOUBLE_TRIBUTE)}
    for _,te in ipairs(eff2) do
      if te:GetValue()(te,sc) then return 0x20001 end
    end
    return 1
  end
  local function filterA(c)
    return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x1b02) or c:IsAttribute(baseC:GetOriginalAttribute())) and not c:IsCode(baseC:GetOriginalCode()) and c:IsReleasable()
  end
  local function filterB(c,g,sc)
    if not c:IsReleasable() or g:IsContains(c) or c:IsHasEffect(EFFECT_EXTRA_RELEASE) then return false end
    local rele=c:GetCardEffect(EFFECT_EXTRA_RELEASE_SUM)
    if rele then
      local remct,ct,flag=rele:GetCountLimit()
      if remct<=0 then return false end
    else return false end
    local sume={c:GetCardEffect(EFFECT_UNRELEASABLE_SUM)}
    for _,te in ipairs(sume) do
      if type(te:GetValue())=='function' then
        if te:GetValue()(te,sc) then return false end
      else return false end
    end
    return true
  end
  local function filterC(c)
    return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x1b02) or c:IsAttribute(baseC:GetOriginalAttribute())) and not c:IsCode(baseC:GetOriginalCode()) and c:IsLocation(LOCATION_HAND)
  end
  local function filterD(c,tp)
    return c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
  end
  local function filterE(sg,e,tp,mg)
    local c=e:GetHandler()
    local mi,ma=c:GetTributeRequirement()
    if mi<1 then mi=ma end
    if not sg:IsExists(filterC,1,nil) or not aux.ChkfMMZ(1)(sg,e,tp,mg) 
      or sg:FilterCount(filterD,nil,tp)>1 then return false end
    local ct=sg:GetCount()
    return sg:CheckWithSumEqual(val_multitribute,mi,ct,ct,c,ma) or sg:CheckWithSumEqual(val_multitribute,ma,ct,ct,c,ma)
  end
  local function condition(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetTributeGroup(c)
    local exg=Duel.GetMatchingGroup(filterA,tp,LOCATION_HAND,0,nil)
    g:Merge(exg)
    local opg=Duel.GetMatchingGroup(filterB,tp,0,LOCATION_MZONE,nil,g,c)
    g:Merge(opg)
    local mi,ma=c:GetTributeRequirement()
    if mi<minc then mi=minc end
    if ma<mi then return false end
    return ma>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-ma and aux.SelectUnselectGroup(g,e,tp,1,ma,filterE,0)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetTributeGroup(c)
    local exg=Duel.GetMatchingGroup(filterA,tp,LOCATION_HAND,0,nil)
    g:Merge(exg)
    local opg=Duel.GetMatchingGroup(filterB,tp,0,LOCATION_MZONE,nil,g,c)
    g:Merge(opg)
    local mi,ma=c:GetTributeRequirement()
    if mi<1 then mi=1 end
    local sg=aux.SelectUnselectGroup(g,e,tp,mi,ma,filterE,1,tp,HINTMSG_RELEASE)
    local remc=sg:Filter(filterD,nil,tp):GetFirst()
    if remc then
      local rele=remc:GetCardEffect(EFFECT_EXTRA_RELEASE_SUM)
      rele:Reset()
    end
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
  end
  local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e:SetCode(EFFECT_SUMMON_PROC)
	e:SetCondition(condition)
	e:SetValue(SUMMON_TYPE_TRIBUTE)
	e:SetOperation(operation)
	return e
end
function BCOT.toa_mata_combination_tagout(baseC,attr1,attr2)
  local function filter2(c,e,tp)
    return c:IsLevel(6) and c:IsSetCard(0x1b02) and c:IsAttribute(attr2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
  end
  local function filter1(c,e,tp)
    return c:IsLevel(6) and c:IsSetCard(0x1b02) and c:IsAttribute(attr1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
      and Duel.IsExistingTarget(filter2,tp,LOCATION_GRAVE,0,1,c,e,tp)
  end
  local function condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()==0
  end
  local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if e:GetHandler():GetSequence()<5 then ft=ft+1 end
    if chk==0 then 
      return ft>1 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) 
        and Duel.IsExistingTarget(filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectTarget(tp,filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectTarget(tp,filter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
    local g=Duel.GetTargetCards(e)
    if g:GetCount()==0 then return end
    if g:GetCount()>ft then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      g=g:Select(tp,ft,ft,nil)
    end
    local tc=g:GetFirst()
    for tc in aux.Next(g) do
      Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
      --Cannot attack this turn
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetDescription(3206)
      e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_CANNOT_ATTACK)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e1)
    end
    Duel.SpecialSummonComplete()
  end
  local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e:SetType(EFFECT_TYPE_QUICK_O)
  e:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e:SetRange(LOCATION_MZONE)
  e:SetCode(EVENT_FREE_CHAIN)
  e:SetCondition(condition)
  e:SetCost(cost)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end
--Kanohi
function BCOT.kanohi_selfdestruct(baseC)
  local function filter(c,ec)
    return c:GetEquipTarget()==ec and c:IsSetCard(0xb04)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return eg:IsExists(filter,1,c,c:GetEquipTarget()) end
    c:CreateEffectRelation(e)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
      Duel.Destroy(c,REASON_EFFECT)
    end
  end
  local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_DESTROY)
  e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e:SetRange(LOCATION_SZONE)
  e:SetCode(EVENT_EQUIP)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end
function BCOT.kanohi_search(baseC, targetCode)
  local function filterA(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
  end
  local function filterB(c)
    return c:IsCode(targetCode) and c:IsAbleToHand()
  end
  local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(filterA,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,filterA,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(filterB,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstMatchingCard(filterB,tp,LOCATION_DECK,0,nil)
    if tc then
      Duel.SendtoHand(tc,tp,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,tc)
    end
  end
  
	local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e:SetProperty(EFFECT_FLAG_DELAY)
	e:SetCode(EVENT_TO_GRAVE)
	e:SetCost(cost)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end
function BCOT.kanohi_revive(baseC, targetCode)
  local function filter(c,e,tp,ec)
    return c:IsCode(targetCode) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) and ec:CheckEquipTarget(c)
  end
  local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
    Duel.Release(g,REASON_COST)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return filter(chkc,e,tp,c) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
    if chk==0 then 
      return Duel.IsExistingTarget(filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
      if Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP) then
        Duel.Equip(tp,c,tc)
      end
    end
  end
  
  local e=Effect.CreateEffect(baseC)
  e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
  e:SetType(EFFECT_TYPE_IGNITION)
  e:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e:SetRange(LOCATION_GRAVE)
  e:SetCost(cost)
  e:SetTarget(target)
  e:SetOperation(operation)
  return e
end
function BCOT.kanohi_xyz(baseC)
  local function filterA(c,e,tp,lv)
    return c:IsSetCard(0x1b02) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false)
  end
  local function filterB(c,tp,sg)
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
    return c:IsSetCard(0xb02) and c:IsXyzSummonable(sg:GetFirst(),Group.Merge(g,sg)) and Duel.GetLocationCountFromEx(tp,tp,Group.Merge(g,sg),c)>0
  end
  local function filterC(c,e,tp,lv)
    return filterA(c,e,tp,lv) and Duel.IsExistingMatchingCard(filterB,tp,LOCATION_EXTRA,0,1,nil,tp,Group.FromCards(c))
  end
  local function condition(e,tp,eg,ep,ev,re,r,rp)
    return bcot.kanohi_con(e,{0x1b02}) and e:GetHandler():GetEquipTarget():IsControler(tp)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ec=e:GetHandler():GetEquipTarget()
    if chk==0 then
      return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ec and ec:HasLevel()
        and Duel.IsExistingMatchingCard(filterC,tp,LOCATION_HAND,0,1,nil,e,tp,ec:GetLevel())
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
  end
  local function operation(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not (ec and ec:HasLevel() and e:GetHandler():IsRelateToEffect(e)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,filterA,tp,LOCATION_HAND,0,1,1,nil,e,tp,ec:GetLevel())
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local xyzg=Duel.SelectMatchingCard(tp,filterB,tp,LOCATION_EXTRA,0,1,1,nil,tp,g)
      if xyzg:GetCount()>0 then
        Duel.BreakEffect()
        Duel.XyzSummon(tp,xyzg:GetFirst(),g:GetFirst())
      end
    end
  end
  
  local e=Effect.CreateEffect(baseC)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetRange(LOCATION_SZONE)
	e:SetCondition(condition)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
function BCOT.greatkanohi_con(e)
  return bcot.kanohi_con(e,{0xb02,0xb07})
end
function BCOT.noblekanohi_con(e)
  return bcot.kanohi_con(e,{0xb02,0xb07,0xb03})
end
function BCOT.kanohi_con(e,setcodes) --Generalization
  local ec=e:GetHandler():GetEquipTarget()
  if ec then
    local be=ec:IsHasEffect(0xb04000) --EFFECT_KANOHI_SETCODE backdoor
    for _,setcode in pairs(setcodes) do
      if ec:IsSetCard(setcode) or (be and be:GetValue()==setcode) then return true end
    end
  end
  
  return false
end