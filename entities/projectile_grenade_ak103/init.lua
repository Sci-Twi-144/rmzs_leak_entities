--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local EffectData = EffectData
local util_Effect = util.Effect

ENT.Base = "projectile_arrow_sli"
ENT.Model = "models/items/ar2_grenade.mdl"

ENT.NoNails = true
ENT.HitOneTime = true

function ENT:InitProjectile()
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.55, 0)
	self:SetTrigger(true)

	self.TimeCreated = CurTime()
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end
	
	self:EmitSound("npc/barnacle/barnacle_gulp2.wav", 70, 120, 0.75, CHAN_WEAPON + 20)
	self:EmitSound("vehicles/airboat/pontoon_impact_hard1.wav", 65, 250, 0.5, CHAN_WEAPON + 21)
	self:Explode()
	--self:Remove()
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local pos = self:GetPos()
	local owner = self:GetOwner()
	
	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()
		util.BlastDamagePlayer(source, owner, pos, self.ProjRadius * (owner.ExpDamageRadiusMul or 1), self.ProjDamage or 68, DMG_ALWAYSGIB, self.ProjTaper or 0.75)
	end

	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	util_Effect("Explosion", effectdata)

	self:Remove()
end