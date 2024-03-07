--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.CreateTime = CurTime()

	self:SetModel("models/rmzs/healgear/healmine_placed.mdl")
	self:SetModelScale(1)
	self:DrawShadow(false)
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)
	self:SetARMTime(self:GetOwner().InstantDetonation and 2 or 4)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(1)
		phys:SetMaterial("metal")
		phys:SetDamping(0.5, 1)
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	if not self.Exploded then
		local attacker = dmginfo:GetAttacker()
		if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
			self:Remove() -- Destroy without explosive damage like mines.
		end
	end
end

function ENT:PhysicsCollide(data, phys)
	if 20 < data.Speed and 0.25 < data.DeltaTime then
		self:EmitSound("physics/metal/metal_grenade_impact_soft"..math.random(1,3)..".wav", 75, 150)
	end

	local normal = data.HitNormal

	if normal.z > -0.7 or (data.HitEntity and not data.HitEntity:IsWorld()) or self.Planted then
		normal = data.OurOldVelocity:GetNormalized()
		phys:SetVelocityInstantaneous((2 * data.HitNormal * data.HitNormal:Dot(normal * -1) + normal) * math.max(300, data.Speed) * 0.5)

		return
	end
	self.Planted = true
	self.PhysicsData = data
	self:SetPos(self:GetPos() + Vector(0, 0, 5))
	self:EmitSound("weapons/c4/c4_plant.wav", 85, 130)
end

function ENT:Think()
	if self.Exploded then
		self:Remove()
		return
	end

	if self.Planted and not self.NoColl then
		local data = self.PhysicsData
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end

		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetAngles(Angle(0, 0, 0))
		self:SetPos(data.HitPos)

		self.NoColl = true
	end

	self:NextThink(CurTime() + 0.1)

	local owner = self:GetOwner()
	if not owner:IsValidLivingHuman() then self:Remove() return end

	if self.CreateTime + self:GetARMTime() > CurTime() then return true end

	local pos = self:GetPos() + self:GetUp() * 2
	if self:GetExplodeTime() == 0 then
		for k, v in pairs(util.BlastAlloc(self, owner, pos, 60)) do
			if v:IsValidLivingHuman() and ((v:Health() / v:GetMaxHealth()) <= 0.5) then
				self:SetExplodeTime(CurTime() + self.ExplosionDelay)
				self:EmitSound("items/suitchargeok1.wav")

				local phys = self:GetPhysicsObject()
				phys:EnableMotion(true)
				phys:AddVelocity(Vector(0, 0, 260))

				break
			end
		end
	elseif CurTime() >= self:GetExplodeTime() then
		self:Explode()
	end

	return true
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local pos = self:GetPos()
		local mul = owner.InstantDetonation and 0.9 or 1

		local ent = ents.Create("env_mediccloud")
		if ent:IsValid() then
			ent:SetPos(self:GetPos())
			ent:SetOwner(self:GetOwner())
			ent.Ticks = 10
			ent.TickTime = 0.1
			ent.HealPower = 5 * mul
			ent:Spawn()
		end
	end
end
