--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_arrow_zea"
SWEP.Primary.ProjVelocity = 1300

function SWEP:EntModify(ent)
	ent.ProjTaper = self.Primary.ProjExplosionTaper
end