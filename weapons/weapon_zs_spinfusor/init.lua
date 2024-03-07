--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_disc"
SWEP.Primary.ProjVelocity = 1500

function SWEP:EntModify(ent)
	ent.ProjRadius = self.Primary.ProjExplosionRadius
	ent.ProjTaper = self.Primary.ProjExplosionTaper
end
