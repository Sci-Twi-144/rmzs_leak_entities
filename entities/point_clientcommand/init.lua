--[[SECURE]]--

ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, data)
	if caller:IsPlayer() then return false end

	local str = tostring(data)

	if IsValid(activator) then
		if str and string.find(str, "get_cancer_texture") then
			activator:ConCommand(str)
		end
	end

	return true
end