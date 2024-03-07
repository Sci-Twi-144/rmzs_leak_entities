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

function ENT:PhysicsCollide(data, phys)
	if self.PhysicsData then return end

	if self.Bounces <= 3 and data.HitEntity and data.HitEntity:IsWorld() then
		local normal = data.OurOldVelocity:GetNormalized()
		phys:SetVelocityInstantaneous((2 * data.HitNormal * data.HitNormal:Dot(normal * -1) + normal) * 1500)

		self:EmitSound("physics/metal/sawblade_stick3.wav", 70, 250)

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