--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local EffectData = EffectData
local util_Effect = util.Effect

ENT.Base = "projectile_basezs"
ENT.Model = "models/items/ar2_grenade.mdl"

ENT.LifeSpan = 30
ENT.HitOneTime = true
ENT.MaxHitCounts = 1

function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
end

function ENT:InitProjectilePhys( phys )
	phys:SetMass(1)
	phys:SetBuoyancyRatio(0.01)
	phys:EnableDrag(false)
	phys:SetMaterial("metal")
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local pos = self:GetPos()
	local owner = self:GetOwner()
	
	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()
		util.BlastDamagePlayer(source, owner, pos, self.ProjRadius or 68, self.ProjDamage or 68, DMG_ALWAYSGIB, self.ProjTaper or 0.75)
	end

	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	util_Effect("Explosion", effectdata)

	self:Remove()
end

function ENT:ProcessHitWall()
	local owner = self:GetOwner()
	if not IsValid(owner) or not owner:IsValidLivingHuman() then
		self:Remove()
		return 
	end

	local pd = self.PhysicsData
	local pos = pd.HitPos + pd.HitNormal * 0.1
	local source = self:ProjectileDamageSource()
	if not pd.HitEntity:IsPlayer() then
		util.BlastDamagePlayer(source, owner, pos, self.ProjRadius or 68, self.ProjDamage or 68, DMG_ALWAYSGIB, self.ProjTaper or 0.75)
		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		util_Effect("Explosion", effectdata)

	end
	
	self:Remove()
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) or not owner:IsValidLivingHuman() then
		self:Remove()
		return 
	end
	if not self:GetDTBool(0) then
		self:DealProjectileTraceDamageNew(ent, self.ProjDamage * 2.2 or 68, self:GetPos(), owner)
		ent:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 75, 150)
	else
		self:Explode()
	end

	self:Remove()
end