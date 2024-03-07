if not SERVER then return end
ENT.Type = "point"

function ENT:KeyValue(key, val)
	if key == "sigilgrouping" then
		GAMEMODE.SigilGrouping = tonumber(val) or 0
	end
end