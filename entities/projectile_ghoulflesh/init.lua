--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.PrecacheModel("models/props/cs_italy/orange.mdl")

local vector_origin = vector_origin

function ENT:Initialize()
	self.DeathTime = CurTime() + 30

	self:SetModel("models/props/cs_italy/orange.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionBounds(vector_origin,vector_origin)
	self:SetColor(Color(255, 255, 0, 255))
	self:SetupGenericProjectile(true)
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end

	if self.DeathTime <= CurTime() then
		self:Remove()
	end
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity)
	if self.Exploded then return end
	self.Exploded = true
	self.DeathTime = 0

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	if eHitEntity:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", eHitEntity, owner) then
		eHitEntity:ApplyZombieDebuff("slow", 5, {Applier = owner}, true, 8)
		eHitEntity:AddLegDamage(2)
	end

	if eHitEntity.IsForceFieldShield and eHitEntity:IsValid() then
		eHitEntity:PoisonDamage(10, owner, self)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
	util.Effect("hit_flesh", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	if not util.HitFence(self, data, phys) then
		self.PhysicsData = data
	end

	self:NextThink(CurTime())
end
