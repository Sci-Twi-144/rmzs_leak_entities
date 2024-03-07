include("shared.lua")

function ENT:Draw()
end

function ENT:Initialize()
	self:GetOwner().Poison = self
end
