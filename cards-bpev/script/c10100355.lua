--Rahi Nui, Vengeful Chimera
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Material
	Fusion.AddProcMixN(c,true,true,aux.TRUE,3) -- placeholder for use in 10100354 test
	c:EnableReviveLimit()
end

