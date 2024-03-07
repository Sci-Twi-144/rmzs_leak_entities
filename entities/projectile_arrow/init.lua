AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Type = "anim"
ENT.Base = "projectile_basezs"
ENT.Model = "models/Items/CrossbowRounds.mdl"

ENT.LifeSpan = 15

ENT.HitOneTime = false
ENT.MaxHitCounts = 20

function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetTrigger(true)
	self:EmitSound("weapons/crossbow/bolt_fly4.wav")
end

function ENT:InitProjectilePhys( phys )
	phys:SetBuoyancyRatio(0.01)
	phys:EnableDrag(false)
end


function ENT:ProcessHitEntity( ent )
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	ent:EmitSound(math.random(2) == 1 and "weapons/crossbow/hitbod"..math.random(2)..".wav" or "ambient/machines/slicer"..math.random(4)..".wav", 75, 150)
	self:DealProjectileTraceDamageNew(ent, self.ProjDamage, self:GetPos(), owner, self)
	self.ProjDamage = self.ProjDamage * (self.ProjTaper or 1) 
end