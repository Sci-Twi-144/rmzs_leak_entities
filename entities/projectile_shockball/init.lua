--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/Items/CrossbowRounds.mdl"
ENT.LifeSpan = 15
ENT.HitOneTime = true
ENT.HitCounts = 0
ENT.MaxHitCounts = 1

ENT.Targeting = nil
ENT.Target = nil
ENT.Radius = 256
function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.3, 0)
	self:SetupGenericProjectile(false)
	self:SetTrigger(true)

	self.TimeCreated = CurTime()
end

ENT.NextVisThink = 0
function ENT:Think(arguments)
	if self.NextVisThink <= CurTime() then
		self.NextVisThink = CurTime() + 0.1
		local radius = self.Radius
		local owner = self:GetOwner()
		local pos = self:GetPos()
		for _, ent in pairs(util.BlastAlloc(self, owner, pos, radius)) do
			if ent:IsValidLivingZombie() and rawget(PlayerIsMarked, ent) <= CurTime() then -- target them anyways
				self.Target = ent
				rawset(PlayerIsMarked, ent, CurTime() + 0.75)
				break
			end
		end
	end

	local target = self.Target
	if IsValid(target) and target:IsValidLivingZombie() then
		local targetpos = target:LocalToWorld(target:OBBCenter() + Vector(0, 0, 1))
		local direction = (targetpos - self:GetPos()):GetNormal()

		self:SetAngles(direction:Angle())

		local airtime = CurTime() - self.TimeCreated
		local speedmul = self.StayAndExp and 0 or math.Clamp(1 + airtime, 1, 9)
		--print(speedmul)
		local phys = self:GetPhysicsObject()
		phys:SetVelocityInstantaneous(direction * (136 * speedmul))
	end
	self.BaseClass.Think(self)
end

function ENT:ProcessHitWall()
	self:EmitSound("weapons/stunstick/spark"..math.random(3)..".wav", 160, 190)
	self:Remove()
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	if ent:IsValidLivingZombie() then
		self:DealProjectileTraceDamageNew(ent, (self.ProjDamage or 66), self:GetPos(), owner)
		ent:AddLegDamageExt(4.5, owner, self:ProjectileDamageSource(), SLOWTYPE_PULSE)
		ent:ApplyZombieDebuff("shockdebuff", 4, {Applier = owner}, true, 38)
		self:EmitSound("weapons/stunstick/spark"..math.random(3)..".wav", 75, 160)
		self:Remove()
	end
end