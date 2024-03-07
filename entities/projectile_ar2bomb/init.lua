--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NoNails = true

ENT.Base = "projectile_arrow_sli"

ENT.HitOneTime = false
ENT.LifeSpan = 6
ENT.Model = "models/dav0r/hoverball.mdl"

ENT.LengthTraceForward = 15

function ENT:InitProjectile()
	self.Bounces = 0
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.2)
	self:SetupGenericProjectile(false)

	self.Creation = UnPredictedCurTime()
end

function ENT:PhysicsUpdate(phys)
	if not self.Done then
		self:TraceHits()
	end

	local livetime = UnPredictedCurTime() - self.Creation
	local vel = phys:GetVelocity()
	--local physang = vel:Angle()
	--local vr = physang:Right() * math.cos(CurTime() * 5) * (1 + livetime) * 3 * (self.ShotMarker == 0 and 1 or -1)

	local newvel = vel --+ vr

	phys:SetVelocityInstantaneous(newvel)
end

function ENT:PhysicsCollide(data, phys)
	if self.PhysicsData then return end

	if self.Bounces <= 5 and data.HitEntity and data.HitEntity:IsWorld() then
		local normal = data.OurOldVelocity:GetNormalized()
		phys:SetVelocityInstantaneous((2 * data.HitNormal * data.HitNormal:Dot(normal * -1) + normal) * 700)

		self:EmitSound("npc/roller/mine/rmine_explode_shock1.wav", 75, 100)
		--self:EmitSound("weapons/irifle/irifle_fire2.wav", 75, 100, 1, CHAN_WEAPON)

		if IsFirstTimePredicted() then
			local effectdata = EffectData()
				effectdata:SetOrigin(data.HitPos)
				--effectdata:SetNormal(data:GetNormal())
			util.Effect("cball_bounce", effectdata)
		end

		self.Bounces = self.Bounces + 1
	elseif self.Bounces >= 5 then
		self:Explode()
	end

	self:NextThink(CurTime())
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	ent:EmitSound("weapons/irifle/irifle_fire2.wav", 75, 100)
	if owner ~= self then
		self:DealProjectileTraceDamageNew(ent, (self.ProjDamage or 50), self:GetPos(), owner)
	end
end

function ENT:Explode()
	self:EmitSound("ambient/levels/labs/electric_explosion4.wav", 75, 100)
	self:EmitSound("npc/scanner/scanner_electric2.wav", 75, 100)

	local pos = self:GetPos()
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	if owner ~= self then
		util.BlastDamagePlayer(source, owner, pos, 96 * (owner.ExpDamageRadiusMul or 1), self.ProjDamage or 50, DMG_ALWAYSGIB, 0.95)
	end

	for _, ent in pairs(util.BlastAlloc(self, owner, pos, 96 * (owner.ExpDamageRadiusMul or 1))) do
		if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) then
			ent:AddLegDamageExt( (self.ProjDamage / 5) / 1.6, owner, self, SLOWTYPE_PULSE)
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
	util.Effect("cball_explode", effectdata)
	util.Effect("cball_bounce", effectdata)

	self:Remove()
end