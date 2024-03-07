--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + self.LifeTime

	self:SetModel("models/weapons/w_grenade.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(4)
		phys:SetMaterial("metal")
	end

	self.Trail = util.SpriteTrail( self, 0, Color( 255, 0, 0 ), true, 8, 1, 1.5, 0.05, "sprites/bluelaser1" )
end

function ENT:PhysicsCollide(data, phys)
	if self:GetOwner().InstantDetonation then
		self:Explode()
	end
	
	if 20 < data.Speed and 0.25 < data.DeltaTime then
		self:EmitSound("physics/metal/metal_grenade_impact_hard"..math.random(3)..".wav")
	end
end

function ENT:Think()
	if self.Exploded then
		self:Remove()
	elseif self.DieTime <= CurTime() then
		self:Explode()
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local pos = self:GetPos()
		local mul = owner.InstantDetonation and 0.9 or 1

		-- Some old ze maps use filter_damage_type with DMG_BLAST to check for grenades
		util.BlastDamagePlayer(self, owner, pos, self.GrenadeRadius or 256, (self.GrenadeDamage or 256) * mul, GAMEMODE.ZombieEscape and DMG_BLAST or DMG_ALWAYSGIB)

		local effectdata = EffectData()
			effectdata:SetOrigin(pos + Vector(0, 0, -1))
			effectdata:SetNormal(Vector(0, 0, -1))
		util.Effect("decal_scorch", effectdata)

		self:EmitSound("npc/env_headcrabcanister/explosion.wav", 85, 100)
		ParticleEffect("dusty_explosion_rockets", pos, angle_zero)
	end
end
