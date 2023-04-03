--Krana Vu-Kal, Transporter
local s,id=GetID()
function s.initial_effect(c)
  --Link Summon
	Link.AddProcedure(c,s.filter0,1,1)
	c:EnableReviveLimit()
  --No Link Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
  --Xyz Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTarget(s.target2)
  e2:SetOperation(s.operation2)
  e2:SetCountLimit(1)
  c:RegisterEffect(e2)
  --Banish
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetCondition(s.condition3)
  e3:SetTarget(s.target3)
  e3:SetOperation(s.operation3)
  e3:SetLabelObject(c)
  e3:SetCountLimit(1)
  c:RegisterEffect(e3)
end
function s.filter2a(c,e,tp)
  local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
  return #(pg-c)==0 and c:IsFaceup() and c:IsSetCard(0xb08) and c:IsLevel(4) and e:GetHandler():GetLinkedGroup():IsContains(c)
    and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,pg)
end
function s.filter2b(c,e,tp,mc,pg)
  return c:IsSetCard(0xb08) and c:IsType(TYPE_XYZ) 
    and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and mc:IsCanBeXyzMaterial(c,tp) 
    and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter2a(chkc,e) end
  if chk==0 then return Duel.IsExistingTarget(s.filter2a,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,s.filter2a,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
	if tc and s.filter2a(tc,e,tp) then
    local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,pg)
    local sc=g:GetFirst()
    if sc then
      sc:SetMaterial(tc)
      Duel.Overlay(sc,tc)
      Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
      sc:CompleteProcedure()
    end
  end
end
function s.filter3(c)
  return c:IsSetCard(0xb08) and c:IsAbleToHand()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSetCard(0xb08)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
  Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
      local e1=Effect.CreateEffect(e:GetLabelObject()) --Have to use the Vu-Kal stored in LabelObject so ReturnToField passes the effect ownership check
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetCode(EVENT_PHASE+PHASE_END)
      e1:SetOperation(function(e) Duel.ReturnToField(e:GetLabelObject()) end)
      e1:SetLabelObject(c)
      e1:SetCountLimit(1)
      e1:SetReset(RESET_PHASE+PHASE_END)
      Duel.RegisterEffect(e1,tp)
      
      if Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
        if #g>0 then
          Duel.SendtoHand(g,nil,REASON_EFFECT)
        end
      end
		end
	end
end