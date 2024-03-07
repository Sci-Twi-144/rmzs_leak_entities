--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_thruster"
SWEP.Primary.ProjVelocity = 1500
--SWEP.Primary.ProjExplosionTaper = 0.72

function SWEP:EntModify(ent)
	self:SetDTEntity(0,ent)

	ent.ProjRadius = self.Primary.ProjExplosionRadius
	ent.ProjTaper = self.Primary.ProjExplosionTaper
	ent.LifeSpan = ent.LifeSpan + ent.LifeSpan * (1/(self:GetOwner().ProjectileSpeedMul or 1) - 1) * 0.6

	self:SetNextSecondaryFire(CurTime() + 0.5)
end