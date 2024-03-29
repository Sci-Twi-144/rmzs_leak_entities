--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_bomb_sticky"
SWEP.Primary.ProjVelocity = 850

function SWEP:EntModify(ent)
	self:SetNextSecondaryFire(CurTime() + 0.2)
	ent.ProjRadius = self.Primary.ProjExplosionRadius
	ent.ProjTaper = self.Primary.ProjExplosionTaper
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() > CurTime() then return end
	for k,v in pairs(ents.FindByClass(self.Primary.Projectile)) do
		if v:GetOwner() == self:GetOwner() then
			v:Explode()
		end
	end

	self:SetNextSecondaryFire(CurTime() + 0.2)
end
