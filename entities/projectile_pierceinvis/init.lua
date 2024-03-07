--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_juggernaut"
ENT.LifeSpan = 15
ENT.HitCounts = 0
ENT.MaxHitCounts = 10
ENT.HitOneTime = false

function ENT:ProcessHitEntity( ent )
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	if self.HitCounts >= self.MaxHitCounts then self.Done = true self:Remove() return end

	self.HitCounts = self.HitCounts + 1 --hmm

	local dmg = self.ProjDamage / math.max((self.HitCounts * 0.5), 1)
	
	ent:EmitSound(math.random(2) == 1 and "weapons/crossbow/hitbod"..math.random(2)..".wav" or "ambient/machines/slicer"..math.random(4)..".wav", 75, 180)
	self:DealProjectileTraceDamageNew(ent, dmg, self:GetPos(), owner)
end
