--Quest for the Masks
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
  e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
  e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
  e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
  e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
s.listed_series={0xb02,0x2b04,0x1b04,0xb04}
function s.filter1(c,ec)
	return not c:IsForbidden() and (c:IsSetCard(0x1b04) or c:IsSetCard(0x2b04)) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
  return ec:IsSetCard(0xb02)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil,ec) end
	local eqg=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_DECK,0,nil,ec)
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,eqg,1,0,0)
  ec:CreateEffectRelation(e)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  local ec=eg:GetFirst()
  if c:IsRelateToEffect(e) and ec:IsRelateToEffect(e) and ec:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil,ec)
    if g:GetCount()>0 then
      Duel.Equip(tp,g:GetFirst(),ec)
    end
  end
end
function s.filter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xb04) and c:IsAbleToGraveAsCost()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_HAND,0,nil)
	local ct=math.min(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),g:GetCount())
	local sg=g:Select(tp,1,ct,nil)
	e:SetLabel(sg:GetCount())
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.filter3(c,e,tp,ct)
  return c:IsLevelBelow(ct) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local ct=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xb04):GetClassCount(Card.GetCode)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and s.filter3(chkc,e,tp,ct) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.filter3,tp,LOCATION_REMOVED,0,1,nil,e,tp,ct) end
  local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
    Duel.BreakEffect()
    Duel.Destroy(c,REASON_EFFECT)
  end
end