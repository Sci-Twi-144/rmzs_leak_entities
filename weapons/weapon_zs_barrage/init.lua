--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_grenade_bouncy"
SWEP.Primary.ProjVelocity = 600

function SWEP:PhysModify(physobj)
end

function SWEP:EntModify(ent)
	ent.ProjRadius = self.Primary.ProjExplosionRadius
	ent.ProjTaper = self.Primary.ProjExplosionTaper
end
