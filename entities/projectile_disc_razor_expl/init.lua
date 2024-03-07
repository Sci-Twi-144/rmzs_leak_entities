--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NoNails = true

ENT.Base = "projectile_arrow_sli"

ENT.HitOneTime = true
ENT.LifeSpan = 3
ENT.Model = "models/props_junk/sawblade001a.mdl"

ENT.LengthTraceForward = 30

function ENT:InitProjectile()
	self.Bounces = 0

	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.25, 0)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetTrigger(true)
	self:SetupGenericProjectile(false)

	self.Creation = UnPredictedCurTime()
end

function ENT:PhysicsCollide(data, physobj)
	self.PhysicsData = data
	self:NextThink(CurTime())
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode()
	end

	if self.Exploded then
		local pos = self:GetPos()
		local alt = self:GetDTBool(0)

		if not alt then
			local effectdata = EffectData()
				effectdata:SetOrigin(pos)
			util.Effect("explosion_rocket", effectdata)
		else
			self:EmitSound(")weapons/explode5.wav", 80, 130)
		end

		self:Remove()
	end
end

function ENT:ProcessHitEntity(ent)
	self:Explode()
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local pos = self:GetPos()

		local source = self:ProjectileDamageSource()
		util.BlastDamagePlayer(source, owner, pos, 99 * (owner.ExpDamageRadiusMul or 1), self.ProjDamage, DMG_ALWAYSGIB, 0.75)
	end
end