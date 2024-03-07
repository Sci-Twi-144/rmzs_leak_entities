--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

--[[function SWEP:Think()
	self.BaseClass.Think(self)

	self:BarricadeGhostingThink()
end

function SWEP:Holster()
	if self:GetOwner():IsValid() then
		self:GetOwner():SetBarricadeGhosting(false)
	end

	return self.BaseClass.Holster(self)
end]]
