--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/combine_helicopter/helicopter_bomb01.mdl"

ENT.ExplodeTime = 0
ENT.LifeSpan = 3
ENT.HitOneTime = true
ENT.MaxHitCounts = 1

function ENT:InitProjectile()
	self:SetColor(Color(255, 255, 0))
	self:PhysicsInitSphere(3)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.2, 0)
	self:DrawShadow(false)
	self:SetupGenericProjectile(true)

	self.Bounces = 2
	self.ExplodeTime = CurTime() + self.LifeSpan
	self.Grace = CurTime() + 0.1
end

function ENT:Think()
	if self.ExplodeTime <= CurTime() then
		self:Explode(self:GetPos())
	end

	if self.PhysicsData then
		if self.Bounces <= 0 or self.PhysicsData.HitEntity.ZombieConstruction then
			self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
		end

		local phys = self.PhysicsData.PhysObject
		if phys:IsValid() then
			local hitnormal = self.PhysicsData.HitNormal
			local vel = self.PhysicsData.OurOldVelocity
			local normal = vel:GetNormalized()
			phys:SetVelocityInstantaneous((2 * hitnormal * hitnormal:Dot(normal * -1) + normal) * vel:Length() * 0.68)
		end

		if CurTime() >= self.Grace then
			self.Bounces = self.Bounces -1
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

	local owner = self:GetOwner()

	if owner:IsValidLivingHuman() then
		local source = self:ProjectileDamageSource()
		util.BlastDamagePlayer(source, owner, hitpos, self.ProjRadius or 82, self.ProjDamage or 29, DMG_ALWAYSGIB, self.ProjTaper or 0.92)
	end

	self:EmitSound(")weapons/explode5.wav", 80, 130)
	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end