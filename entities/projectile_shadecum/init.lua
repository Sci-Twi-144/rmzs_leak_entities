--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/medbridge_post01.mdl")
	self:PhysicsInitBox(Vector(-16.285, -16.285, -0.29) * self.ModelScale, Vector(16.285, 16.285, 104.29) * self.ModelScale)
	self:SetModelScale( self.ModelScale)
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	--self:SetCustomCollisionCheck(true)

	local g,f = GetProjectileFlags(self)
	self:SetCustomGroupAndFlags(g,f)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(true)
		phys:Wake()
	end
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end

	if self.Exploded then
		self:Remove()
	end
end

function ENT:Hit(vHitPos, vHitNormal, ent)
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	if ent:IsValid() then
		if not ent:IsPlayer() or (ent:IsPlayer() and ent:Team() ~= TEAM_UNDEAD) then
			ent:TakeSpecialDamage(66 * (ent.PhysicsDamageTakenMul or 1), DMG_GENERIC, owner, self)
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
	util.Effect("hit_shadestone", effectdata)
	util.Effect("hit_stone", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	if ent:IsPlayer() and ent:Team() == TEAM_HUMAN and not self.Exploded then
		self:Hit(data.HitPos, data.HitNormal, data.HitEntity)
	end 
	if self.Control:IsValid() then return end

	self.PhysicsData = data
	self:NextThink(CurTime())
end
