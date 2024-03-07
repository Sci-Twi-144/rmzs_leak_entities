--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/props_junk/rock001a.mdl"

ENT.ExplodeTime = 0
ENT.LifeSpan = 3
ENT.HitOneTime = true
ENT.MaxHitCounts = 1
ENT.TransferEffects = {}
ENT.Tier = 1
ENT.DamageInt = 1

function ENT:InitProjectile()
	self:SetColor(Color(30, 150, 255, 255))
	self:PhysicsInitSphere(3)
	self:SetModel(self.Model)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(1, 0)
	self:SetMaterial("models/props_combine/masterinterface01c")
	self:DrawShadow(false)
	self:SetupGenericProjectile(true)
	
	--[[local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("zombieflesh")
		phys:EnableMotion(true)
		phys:SetMass(15)
		phys:Wake()
		phys:ApplyForceCenter(VectorRand():GetNormalized() * math.Rand(3000, 3200))
		phys:AddAngleVelocity(VectorRand() * 360)
	end]]
	
	self.Bounces = 2
	self.ExplodeTime = CurTime() + self.LifeSpan
	self.Grace = CurTime() + 0.1
	self.Trail = util.SpriteTrail( self, 0, Color(30, 150, 255), true, 8, 1, 1.5, 0.05, "sprites/bluelaser1" )
end

function ENT:Think()
	if self.ExplodeTime <= CurTime() then
		self:Explode(self:GetPos())
	end
	
	if self.PhysicsData then
		if self.Bounces <= 0 or self.PhysicsData.HitEntity.ZombieConstruction then
			self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitEntity)
		end

		local phys = self.PhysicsData.PhysObject
		if phys:IsValid() then
			local hitnormal = self.PhysicsData.HitNormal
			local vel = self.PhysicsData.OurOldVelocity
			local normal = vel:GetNormalized()
			phys:SetVelocityInstantaneous((2 * hitnormal * hitnormal:Dot(normal * -1) + normal) * vel:Length() * 0.68)
		end

		if CurTime() >= self.Grace then
			self.Bounces = self.Bounces -1
		end

		self.PhysicsData = nil
		self.Done = false
	end
	
	self:NextThink(CurTime())
	return true
end

function ENT:ProcessHitEntity( ent )
	self:Explode(self:GetPos(), ent)
end

function ENT:Explode(pos, hitent)
	if self.Exploded then return end
	if not hitent then return end
	self.Exploded = true

	local owner = self:GetOwner()

	if owner:IsValidLivingHuman() and hitent:IsValidLivingZombie() then
		local source = self:ProjectileDamageSource()
		hitent:TakeSpecialDamage(self.DamageInt, DMG_DIRECT, owner, source)
		hitent:AddLegDamageExt(self.DamageInt * 0.5, owner, source, SLOWTYPE_COLD)
	end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(Vector(0,0,1))
		effectdata:SetMagnitude(1)
	util.Effect("explosion_cold", effectdata, true)

	self:EmitSound("physics/glass/glass_largesheet_break"..math.random(1, 3)..".wav", 70, math.random(160, 180))
	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end
