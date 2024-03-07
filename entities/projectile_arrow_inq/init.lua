--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_arrow_cha"

ENT.HitOneTime = false
ENT.MaxHitCounts = 6

function ENT:ProcessHitWall()
	self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal)
	self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 75, 250)
	self.Done = true
	self:Remove()
end

function ENT:ProcessHitEntity( ent )
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	if self.HitCounts >= self.MaxHitCounts then self.Done = true self:Remove() return end

	self.HitCounts = self.HitCounts + 1 --hmm

	local dmg = self.ProjDamage / math.max(self.HitCounts, 1)
	
	ent:EmitSound(math.random(2) == 1 and "weapons/crossbow/hitbod"..math.random(2)..".wav" or "ambient/machines/slicer"..math.random(4)..".wav", 75, 180)
	self:DealProjectileTraceDamageNew(ent, dmg, self:GetPos(), owner)

	if self:GetDTBool(0) and ent:IsValidZombie() then
		ent:ApplyZombieDebuff("zombiestrdebuff", 5, {Applier = owner, Damage = 1.25}, true, 35)
	end
end