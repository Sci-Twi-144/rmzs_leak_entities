--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/dav0r/hoverball.mdl"

ENT.LifeSpan = 4
ENT.HitOneTime = true

function ENT:InitProjectile()
	self.Bounces = 0

	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.05, 0)
	self:SetTrigger(true)
	self:SetupGenericProjectile(true)

	self:Fire("kill", "", self.LifeSpan)
end

function ENT:ProcessHitEntity(ent)
	util.Blood((ent:NearestPoint(self:GetPos()) + ent:WorldSpaceCenter()) / 2, math.random(4, 9), Vector(0, 0, 1), 100)
	ent:TakeSpecialDamage((self.ProjDamage or 22)/(self.Bounces + 1), DMG_SLASH, self:GetOwner(), self:ProjectileDamageSource())
	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	if self.PhysicsData then return end

	if self.Bounces <= 1 and data.HitEntity and data.HitEntity:IsWorld() then
		local normal = data.OurOldVelocity:GetNormalized()
		phys:SetVelocityInstantaneous((2 * data.HitNormal * data.HitNormal:Dot(normal * -1) + normal) * 500)

		self:EmitSound("physics/metal/metal_box_impact_bullet3.wav", 65, 250)

		self.Bounces = self.Bounces + 1
	else
		self.PhysicsData = data
	end

	self:NextThink(CurTime())
end

function ENT:Think()
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if self.PhysicsData then
		self:ProcessHitWall()
	end
end
