--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/props_c17/trappropeller_lever.mdl"
ENT.LifeSpan = 15
ENT.HitOneTime = true
ENT.HitCounts = 0
ENT.MaxHitCounts = 1

function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetupGenericProjectile(false)

	self:EmitSound("weapons/ar2/fire1.wav", 75, 210)
end

function ENT:Explode(hitpos, hitnormal, hitent)
	if self.Exploded then return end
	self.Exploded = true

	--hitpos = hitpos or self:GetPos()
	--hitnormal = hitnormal or self:GetForward()

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()
		--local target = self.PhysicsData.HitEntity

		if hitent:IsValidLivingZombie() and not hitent:GetZombieClassTable().NeverAlive then
			hitent:TakeSpecialDamage(self.ProjDamage or 47, DMG_BULLET, owner, source, hitpos)
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(hitnormal)
	util.Effect("hit_jugger", effectdata)
end

function ENT:ProcessHitEntity( ent )
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	self:Explode(self:GetPos(), self:GetForward(), ent)
	self:Remove()
end
