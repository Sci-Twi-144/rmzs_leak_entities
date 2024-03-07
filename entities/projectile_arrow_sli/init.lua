--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_arrow_cha"
ENT.HitOneTime = true

function ENT:InitProjectile()
	--self:SetModel("models/Items/CrossbowRounds.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.55, 0)
	self:SetTrigger(true)
	--self:SetupGenericProjectile(true)

	self.TimeCreated = CurTime()
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	local airtime = CurTime() - self.TimeCreated
	local dmgmul = math.Clamp(1 + (airtime * 1.2) * (owner.ProjectileSpeedMul or 1), 1, 1.6)
	local alt2 = self:GetDTBool(1)

	self:DealProjectileTraceDamageNew(ent, (self.ProjDamage or 66) * (alt2 and dmgmul or 1), self:GetPos(), owner)
	self:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 75, 80)
	self:Remove()
end