--Bahrag Cahdok, Queen of the Bohrok
function c10100233.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x15c),aux.NonTuner(Card.IsSetCard,0x15c),1)
	c:EnableReviveLimit()
end

