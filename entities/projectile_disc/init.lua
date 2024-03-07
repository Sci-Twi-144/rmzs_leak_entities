--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_arrow"
ENT.Model = "models/Items/CrossbowRounds.mdl"
ENT.LifeSpan = 15
ENT.HitOneTime = true
ENT.HitCounts = 0
ENT.MaxHitCounts = 1

function ENT:InitProjectile()
	self.Touched = {}
	self.OriginalAngles = self:GetAngles()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetTrigger(true)
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local hitpos = self.PhysicsData and self.PhysicsData.HitPos or self:GetPos()
	local normal = self.PhysicsData and self.PhysicsData.HitNormal or Vector(0, 0, 1)

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(normal)
	util.Effect("explosion_fusordisc", effectdata)
	
	local owner = self:GetOwner()
	
	if owner:IsValidLivingHuman() then
		local pos = self:GetPos()
		local source = self:ProjectileDamageSource()

		util.BlastDamagePlayer(source, owner, pos, self.ProjRadius * (owner.ExpDamageRadiusMul or 1), self.ProjDamage, DMG_ALWAYSGIB, 0.75)

		local taper = 1
		for _, ent in pairs(util.BlastAlloc(self, owner, pos, self.ProjRadius * (owner.ExpDamageRadiusMul or 1))) do
			if ent:IsValidLivingZombie() and not SpawnProtection[ent] then
				ent:AddLegDamageExt(self.ProjDamage * 0.075 * taper, self:GetOwner(), self, SLOWTYPE_PULSE)
				taper = taper * 0.98
				if ent:GetStatus("shockdebuff") then
					ent:TakeDamage(self.ProjDamage * 0.25, owner, owner)
				end
			end
		end

	end
end

function ENT:ProcessHitWall()
	self:Explode()
	self:Remove()
end

function ENT:ProcessHitEntity( ent )
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	self:Explode()
	self:Remove()
end