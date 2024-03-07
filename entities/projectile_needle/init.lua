--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/Items/CrossbowRounds.mdl"

ENT.LifeSpan = 30
ENT.HitOneTime = true

function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)

	-- self:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 75, 80)
	self.LastPhysicsUpdate = UnPredictedCurTime()
end

function ENT:PhysicsUpdate(phys)
	if not self.Done then
		self:TraceHits()
	end

	self.LastPhysicsUpdate = UnPredictedCurTime()
	local vel = phys:GetVelocity()
	phys:SetAngles(phys:GetVelocity():Angle())
	phys:SetVelocityInstantaneous(vel)
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.OurOldVelocity, self.PhysicsData.HitEntity)
	end

	self:NextThink(CurTime())
	return true
end

function ENT:ProcessHitEntity(ent)
	self:Hit(self:GetPos(), self:GetPos(), self:GetVelocity():Length(), ent)
end

function ENT:Hit(vHitPos, vHitNormal, vel, hitent)
	if self.Done then return end
	self.Done = true

	local owner = self:GetOwner()

	if hitent.IsCreeperNest then
		hitent:TakeSpecialDamage(self.ProjDamage or 117, DMG_GENERIC, owner, self:ProjectileDamageSource(), self:GetPos())
		hitent:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 75, 80)
	end

	if hitent and hitent:IsValid() and hitent:IsPlayer() then

		local ent = ents.Create("prop_needle2")
		if ent:IsValid() then
			ent:SetPos(vHitPos)
			ent.BleedPerTick = self.ProjDamage * 0.077
			ent:Spawn()
			ent:SetOwner(self:GetOwner())
			ent:SetParent(hitent)
			ent:SetAngles(self:GetAngles())
		end
		hitent:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 75, 80)
		hitent:TakeSpecialDamage(self.ProjDamage or 117, DMG_GENERIC, owner, self:ProjectileDamageSource(), self:GetPos())
	end

	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end
