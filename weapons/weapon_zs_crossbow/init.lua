--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_arrow"
SWEP.Primary.ProjVelocity = 1400

function SWEP:EntModify(ent)
	ent.ProjTaper = self.Primary.ProjExplosionTaper
end