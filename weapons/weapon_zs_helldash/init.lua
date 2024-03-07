--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_minibarrel"
SWEP.Primary.ProjVelocity = 1000

function SWEP:EntModify(ent)
	ent.ProjRadius = self.Primary.ProjExplosionRadius
	ent.ProjTaper = self.Primary.ProjExplosionTaper
end

function SWEP:PhysModify(physobj)
end
