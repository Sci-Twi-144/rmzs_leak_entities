--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"

ENT.HitOneTime = true
--ENT.HitCounts = 0
--ENT.MaxHitCounts = 1
ENT.Model = "models/dav0r/hoverball.mdl"
ENT.IsAoe = true

function ENT:InitProjectile()
	--self.Touched = {}
	self.Bounces = 0
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(2, 0)
	self:SetTrigger(true)

	self:Fire("kill", "", 10)
end

function ENT:InitProjectilePhys(phys)
	phys:EnableGravity(false)
	phys:EnableDrag(false)
end

function ENT:Explode(hitpos, hitnormal, ent)
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()

		util.BlastDamagePlayer(source, owner, self:GetPos(), 50, (self.ProjDamage or 52) * 0.2, DMG_ALWAYSGIB, 0.96)

		if ent:IsValidLivingZombie() and not ent:GetZombieClassTable().NeverAlive then
			ent:TakeSpecialDamage((self.ProjDamage or 49) * 0.9, DMG_GENERIC, owner, source, hitpos)
		end
	end
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	self:Explode(self:GetPos(), self:GetForward(), ent)
	self:Remove()
end

function ENT:ExplodeAlt()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()
		util.BlastDamagePlayer(source, owner, self:GetPos(), self.ProjRadius or 124, (self.ProjDamage or 52) * 2.25, DMG_ALWAYSGIB, self.ProjTaper or 0.75)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetForward())
	util.Effect("explosion_shockcore", effectdata, true, true)

	--[[
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetForward())
	util.Effect("explosion_wispdeath", effectdata, true, true)
	]]

	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker:IsValidLivingHuman() then
		local inflictor = dmginfo:GetInflictor()

		if inflictor:IsValid() and dmginfo:GetDamageType() == DMG_GENERIC and inflictor.ASMD and attacker == self:GetOwner() then
			self:ExplodeAlt()
		end
	end
end
