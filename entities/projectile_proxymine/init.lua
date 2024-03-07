--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.ProjDamage = 235

function ENT:Initialize()
	self.CreateTime = CurTime()

	self:SetModel("models/props_c17/oildrum001.mdl")
	self:SetModelScale(0.16)
	self:DrawShadow(false)
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)
	self:SetMaterial("models/props_canal/canal_bridge_railing_01c")
	self:SetColor(Color(235, 205, 185, 255))
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
			local pos = self:GetPos()

			local effectdata = EffectData()
				effectdata:SetOrigin(pos)
			util.Effect("Explosion", effectdata)

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
		for k, v in pairs(util.BlastAlloc(self, owner, pos, 90)) do
			if v:IsValidLivingZombie() and not v:IsHeadcrab() then
				local nearest = v:NearestPoint(pos)
				if TrueVisibleFilters(pos, nearest, self, v) then
					self:SetExplodeTime(CurTime() + self.ExplosionDelay)
					self:EmitSound("npc/scanner/combat_scan2.wav")

					local phys = self:GetPhysicsObject()
					phys:EnableMotion(true)
					phys:AddVelocity(Vector(0, 0, 260))

					break
				end
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

		util.BlastDamagePlayer(self, owner, pos, 335, self.ProjDamage * mul, DMG_ALWAYSGIB, 0.85)

		for i = 0, 8 do
			local ent = ents.Create("projectile_flak")
			if ent:IsValid() then
				ent:SetPos(self:GetPos())
				ent:SetAngles(self:GetAngles())
				ent:SetOwner(owner)
				ent.ProjDamage = self.ProjDamage * 0.2 * (owner.ProjectileDamageMul or 1)
				ent.ProjSource = self.ProjSource
				ent.Team = self.Team
	
				ent:Spawn()
	
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
	
					local angle = Angle(0, 0, 0)
					angle:RotateAroundAxis(angle:Up(), 45 * i)
					phys:SetVelocityInstantaneous(angle:Forward() * 1000 + Vector(0, 0, 200))
				end
			end
		end

		local effectdata = EffectData()
			effectdata:SetOrigin(pos + Vector(0, 0, -1))
			effectdata:SetNormal(Vector(0, 0, -1))
		util.Effect("decal_scorch", effectdata)

		self:EmitSound("npc/env_headcrabcanister/explosion.wav", 85, 100)
		ParticleEffect("dusty_explosion_rockets", pos, angle_zero)
	end
end
