if not bpev then
	Duel.LoadScript("util-bpev.lua")
end
--Toa Nuva Pohatu
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Material
	Fusion.AddProcMix(c,true,true,10100004,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb0b))
	--Add Spell/Trap
	local e1=bpev.toa_nuva_search(c)
	e1:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e1)
	--Destroy Spells/Traps
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
s.material_setcode={0xb02,0xb0b,0xb0c}
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsRace,RACE_ROCK),tp,LOCATION_MZONE,0,nil)+1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,ct,nil,TYPE_SPELL+TYPE_TRAP)
    if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
