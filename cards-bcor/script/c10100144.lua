--The Ussalry Arrives
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	if s.counter==nil then
		s.counter=true
		s[0]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(s.operation2)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_REMOVE)
		e3:SetOperation(s.operation3)
		Duel.RegisterEffect(e3,0)
	end
	--Shuffle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(s.condition4)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation4)
	e4:SetCountLimit(1,id)
	c:RegisterEffect(e4)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.operation1_1)
	Duel.RegisterEffect(e1,tp)
end
function s.operation1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,s[0],REASON_EFFECT)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	s[0]=0
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	if eg and re then
		local tc=eg:GetFirst()
		while tc do
			if tc==re:GetHandler() and tc:IsSetCard(0xb06) then
				s[0]=s[0]+1		
			end
			tc=eg:GetNext()
		end
	end
end
function s.filter4(c)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsAbleToDeck()
end
function s.condition4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter4,tp,LOCATION_REMOVED,0,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)	
	local g=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_REMOVED,0,1,1,nil)
	g:AddCard(e:GetHandler())
	if g:GetCount()==2 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(p,d,REASON_EFFECT)
	end
end