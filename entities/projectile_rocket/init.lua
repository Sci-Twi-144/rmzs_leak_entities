--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/weapons/w_missile_closed.mdl"

ENT.LifeSpan = 30
ENT.HitOneTime = true
ENT.MaxHitCounts = 1

function ENT:InitProjectile()
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)

	if self:GetDTBool(0) then
		self:SetModelScale(0.4, 0)
	end

	self.DeadTime = CurTime() + self.LifeSpan
	self:SetupGenericProjectile(false)
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode()
	end

	if self.DeadTime <= CurTime() then
		self:Explode()
	end
end

function ENT:ProcessHitEntity(ent)
	self:Explode()
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local pos = self:GetPos()
	local owner = self:GetOwner()
	
	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()
		util.BlastDamagePlayer(source, owner, pos, self.ProjRadius or 85, self.ProjDamage, DMG_ALWAYSGIB, self.ProjTaper or 0.72)
	end

	local alt = self:GetDTBool(0)

	if not alt then
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata)
		util.Effect("explosion_rocket", effectdata)
	else
		self:EmitSound(")weapons/explode5.wav", 80, 130)
	end

	self:Remove()
end
