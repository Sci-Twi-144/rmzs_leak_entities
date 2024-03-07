include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + self.LifeSpan
end
