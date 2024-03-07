--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

--ENT.PointsMultiplier = 1.25
ENT.NoNails = true

ENT.Base = "projectile_arrow_sli"

ENT.HitOneTime = true
ENT.LifeSpan = 3
ENT.Model = "models/dav0r/hoverball.mdl"

ENT.LengthTraceForward = 15

function ENT:InitProjectile()
	self.Bounces = 0

	self:SetColor(Color(0, 255, 0))
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(self.Branch and 0.15 or 0.25, 0)
	self:SetTrigger(true)
	self:SetupGenericProjectile(false)

	self.Creation = UnPredictedCurTime()
end

function ENT:PhysicsUpdate(phys)
	if not self.Done then
		self:TraceHits()
	end

	if not self.Branch then return end

	local livetime = UnPredictedCurTime() - self.Creation
	local vel = phys:GetVelocity()
	local physang = vel:Angle()
	local vr = physang:Right() * math.cos(CurTime() * 5) * (1 + livetime) * 3 * (self.ShotMarker == 0 and 1 or -1)

	local newvel = vel + vr

	phys:SetVelocityInstantaneous(newvel)
end

function ENT:PhysicsCollide(data, phys)
	if self.PhysicsData then return end

	if self.Bounces <= 1 and data.HitEntity and data.HitEntity:IsWorld() then
		local normal = data.OurOldVelocity:GetNormalized()
		phys:SetVelocityInstantaneous((2 * data.HitNormal * data.HitNormal:Dot(normal * -1) + normal) * 700)

		self:EmitSound("ambient/levels/citadel/weapon_disintegrate3.wav", 70, 210)

		self.Bounces = self.Bounces + 1
	else
		self.PhysicsData = data
	end

	self:NextThink(CurTime())
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end


	self:DealProjectileTraceDamageNew(ent, (self.ProjDamage or 66), self:GetPos(), owner)
	--[[
	if ent:IsPlayer() then
		ent:AddLegDamageExt(5.5, owner, self:ProjectileDamageSource(), SLOWTYPE_PULSE)
	end
	]]

	util.Blood(ent:WorldSpaceCenter(), math.max(0, 15), -self:GetForward(), math.Rand(100, 300), true)

	self:Remove()
end