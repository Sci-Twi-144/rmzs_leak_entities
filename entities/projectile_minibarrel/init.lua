--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/props_c17/oildrum001_explosive.mdl"

ENT.ExplodeTime = 0
ENT.LifeSpan = 5
ENT.HitOneTime = true
ENT.MaxHitCounts = 1

function ENT:InitProjectile()
	self:SetAngles(self:LocalToWorldAngles(Angle(90, 0, 0)))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetModelScale(0.2, 0)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetUseType(SIMPLE_USE)
	self:SetupGenericProjectile(true)
	self:Activate()

	self.ExplodeTime = CurTime() + self.LifeSpan
end

function ENT:Think()
	if self.ExplodeTime <= CurTime() then
		self:Explode(self:GetPos())
	end

	if self.PhysicsData then
		if self.PhysicsData.HitEntity.ZombieConstruction then
			self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
		end

		self.PhysicsData = nil
		self.Done = false
	end

	self:NextThink(CurTime())
	return true
end

function ENT:ProcessHitEntity( ent )
	self:Explode(self:GetPos())
end

function ENT:Explode(hitpos, hitnormal, hitent)
	if self.Exploded then return end
	self.Exploded = true
	
	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or self:GetForward()

	local owner = self:GetOwner()

	if owner:IsValidLivingHuman() then
		local source = self:ProjectileDamageSource()
		util.BlastDamagePlayer(source, owner, hitpos, self.ProjRadius or 85, self.ProjDamage or 124, DMG_ALWAYSGIB, self.ProjTaper or 0.9)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(hitnormal)
		util.Effect("Explosion", effectdata)
		util.Effect("explosion_rocket", effectdata)
	self:EmitSound(")weapons/explode5.wav", 80, 130)
	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end