--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_nanites"
SWEP.Primary.ProjVelocity = 1000

function SWEP:EntModify(ent)
	local owner = self:GetOwner()
	ent:SetDTBool(self.Mogus, true)
	ent.ProjRadius = self.Primary.ProjExplosionRadius
end
