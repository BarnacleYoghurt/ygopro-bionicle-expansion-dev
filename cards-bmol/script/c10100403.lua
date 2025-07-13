Duel.LoadScript("util-bmol.lua")
--Avohkii, Sealed Mask of Light
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c)
    --Change name
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetValue(CARD_AVOHKII)
    c:RegisterEffect(e1)
    --Search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SEARCH|CATEGORY_TOHAND|CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCost(Cost.SelfToHand)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,id)
    c:RegisterEffect(e2)
end
s.listed_names={CARD_AVOHKII}
function s.filter2(c)
    return (c:IsCode(CARD_AVOHKII) or (c:IsMonster() and c:ListsCode(CARD_AVOHKII)))
        and c:IsAbleToHand() and not c:IsCode(id)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil)  end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(1-tp,g)
        Duel.ShuffleHand(tp)
        Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
    end
end