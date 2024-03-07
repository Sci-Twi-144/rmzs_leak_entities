include("shared.lua")

function ENT:GetDim()
	local creation_time = self:GetStartTime()
	local time = CurTime()
	local life_time = self:GetDuration()
	local end_time = creation_time + life_time

	if time > end_time - 0.5 then
		return math.Clamp((end_time - time) * 2, 0, 1)
	end

	if time < creation_time + 0.5 then
		return math.max(0, (time - creation_time) * 2)
	end

	return 1
end