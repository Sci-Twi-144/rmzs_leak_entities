--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")


ENT.Base = "projectile_arrow_cha"
ENT.HitOneTime = true

ENT.Model = "models/dav0r/hoverball.mdl"
ENT.LengthTraceForward = 15
ENT.LifeSpan = 0.5

function ENT:InitProjectile()
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.2, 0)
	self:SetTrigger(true)
	self:SetupGenericProjectile(false)

	self.LastPhysicsUpdate = UnPredictedCurTime()
end

local vecDown = Vector()
function ENT:PhysicsUpdate(phys)
	self.BaseClass.PhysicsUpdate(self)

	local dt = UnPredictedCurTime() - self.LastPhysicsUpdate
	self.LastPhysicsUpdate = UnPredictedCurTime()

	vecDown.z = dt * -200
	phys:AddVelocity(vecDown)
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end
	
	self:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 75, 80)

	self:DealProjectileTraceDamageNew(ent, (self.ProjDamage or 66), self:GetPos(), owner)
	ent:AddLegDamageExt(5.5, owner, self:ProjectileDamageSource(), SLOWTYPE_PULSE)

	util.Blood(ent:WorldSpaceCenter(), math.max(0, 15), -self:GetForward(), math.Rand(100, 300), true)
	self:Remove()
end