--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/dav0r/hoverball.mdl"

ENT.LifeSpan = 1.3
ENT.HitOneTime = true
ENT.MaxHitCounts = 1

--ENT.SubProjectile = "projectile_emi_sub"

function ENT:InitProjectile()
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.4)
	self:SetupGenericProjectile(false)

	self:EmitSound("weapons/physcannon/energy_sing_flyby2.wav", 70, math.random(125, 135))

	self.NextShoot = 0
end

function ENT:Think()
	local owner = self:GetOwner()
	if self.PhysicsData then
		self:ProcessHitWall()
	end

	if self.Exploded then
		self:Remove()
	end

	if CurTime() > self.NextShoot then
		self.NextShoot = CurTime() + 0.1
		if not owner:IsValidLivingHuman() then owner = self end
		self:FireBulletsLua(self:GetPos() + self:GetForward() * 10, self:GetForward(), 5, 1, 1, 1, self.ProjDamage, owner, 0.01, "tracer_pcutter", BulletCallback, nil, false, nil, nil, owner:GetActiveWeapon())
	end
end

function ENT:ProcessHitWall()
	self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
end

function ENT:ProcessHitEntity(ent)
	self:Hit(self:GetPos(), self:GetForward(), ent)
end

function ENT:OnRemove()
	self:Hit(self:GetPos(), Vector(0, 0, 1), NULL)
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity)
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
	util.Effect("explosion_emi", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	if self.Done then return end

	if not util.HitFence(self, data, phys) then
		self.Done = true
		phys:EnableMotion(false)
		self.PhysicsData = data
		self:NextThink(CurTime())
	end
end
