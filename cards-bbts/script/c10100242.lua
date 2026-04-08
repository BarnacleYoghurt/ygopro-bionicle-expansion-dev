--Bohrok Servant
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(s.filter0a),aux.FilterBoolFunctionEx(s.filter0b,c))
    --Summon procedure
    Fusion.AddContactProc(c,s.target0,s.operation0,aux.FALSE)
    --Set ATK/DEF
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
end
function s.filter0a(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb09)
end
function s.filter0b(c,bc)
  return c:GetOwner()==1-bc:GetControler()
end
function s.filter0c(c)
    return c:IsAbleToDeckOrExtraAsCost() and (c:IsOnField() or c:IsFaceup())
end
function s.target0(tp)
	return Duel.GetMatchingGroup(s.filter0c,tp,LOCATION_MZONE|LOCATION_GRAVE|LOCATION_REMOVED,0,nil)
end
function s.operation0(g,tp)
    local fu,fd=g:Split(Card.IsFaceup,nil)
    if #fu>0 then Duel.HintSelection(fu,true) end
    if #fd>0 then Duel.ConfirmCards(1-tp,fd) end
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST|REASON_MATERIAL)
end
function s.filter1(c,tp)
  return c:GetOwner()==1-tp
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial():Filter(s.filter1,nil,tp)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        local atk=math.max(tc:GetBaseAttack(), 0)
        local def=math.max(tc:GetBaseDefense(), 0)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_BASE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_BASE_DEFENSE)
        e2:SetValue(def)
        c:RegisterEffect(e2)
    end
end