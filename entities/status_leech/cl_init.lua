include("shared.lua")

function ENT:Draw()
end

function ENT:Initialize()
	self:GetOwner().Leech = self
end
