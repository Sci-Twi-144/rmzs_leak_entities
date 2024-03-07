--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.CreateTime = CurTime()

	self:SetModel("models/props/cs_office/paper_towels.mdl")
	self:SetAngles(Angle(90, 0, 0))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:Fire("kill", "", 30)
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	if not self.Exploded then
		local attacker = dmginfo:GetAttacker()
		if (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD) then
			local pos = self:GetPos()
			local effectdata = EffectData()
				effectdata:SetOrigin(pos)
			util.Effect("Explosion", effectdata)

			self:Explode() -- Destroy without explosive damage like mines.
		end
	end
end

function ENT:StartTouch(ent)

	local owner = self:GetOwner()
	local pos = self:GetPos()

	if self.DieTime ~= 0 and ent:IsValid() and ent:IsPlayer() then
		if not owner:IsValid() then owner = self end

		if ent ~= owner and ent:Team() ~= self.Team then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(owner)
			dmginfo:SetInflictor(owner)
			dmginfo:SetDamage(200)
			dmginfo:SetDamageType(DMG_ALWAYSGIB)
			local effectdata = EffectData()
			effectdata:SetOrigin(ent:GetPos())
			effectdata:SetNormal(dmginfo:GetDamageForce())
			effectdata:SetEntity(self)
			ent:TakeDamageInfo(dmginfo)
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
	self:EmitSound("physics/cardboard/cardboard_box_impact_bullet2.wav", 85, 130)
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

		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetAngles(Angle(90, math.random(0, 359), 0))
		self:SetPos(data.HitPos + Vector(0, 0, 8))

		self.NoColl = true
	end

	self:NextThink(CurTime() + 0.1)

	local owner = self:GetOwner()
	if not owner:IsValidLivingHuman() then self:Remove() return end

	return true
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local pos = self:GetPos()

		local mul = owner.InstantDetonation and 0.9 or 1

		util.BlastDamagePlayer(owner, owner, pos, 384, 512, DMG_ALWAYSGIB, 0.85)

		local effectdata = EffectData()
			effectdata:SetOrigin(pos + Vector(0, 0, -1))
			effectdata:SetNormal(Vector(0, 0, -1))
		util.Effect("decal_scorch", effectdata)

	end
end
