include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self.DieTime = CurTime() + 0.06
end
