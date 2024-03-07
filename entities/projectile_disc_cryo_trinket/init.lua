--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Homing = true
ENT.Target = nil

function ENT:Initialize()
	self.Bounces = self.Secondary and 4 or 0

	self:SetModel("models/props_junk/sawblade001a.mdl")
	self:PhysicsInitSphere(3)
	self:SetSolid(SOLID_BBOX) -- SOLID_VPHYSICS
	self:SetModelScale(2, 0)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetTrigger(true)
	self:SetupGenericProjectile(false)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self.DieTime = CurTime() + self.LifeSpan
	self.DamageStored = 0
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:EnableMotion(true)
		phys:Wake()
		phys:AddAngleVelocity(-1 *  Vector(0,0,100000))
	end
	self.WaveSound = CreateSound(self, "ambient/wind/wind1.wav")
	self.WaveSound:PlayEx(70, 250)
	self.Exploded = false
	
	--self.Trail = util.SpriteTrail( self, 0, RED, true, 8, 1, 1.5, 0.05, "sprites/bluelaser1" )
	self:Fire("kill", "", self.LifeSpan + 1)	
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end
	
	local owner = self:GetOwner()
	
	if self.Bounces <= 3 and data.HitEntity and data.HitEntity:IsWorld() then
		local normal = data.OurOldVelocity:GetNormalized()
		phys:SetVelocityInstantaneous((2 * data.HitNormal * data.HitNormal:Dot(normal * -1) + normal) * 150 * (owner.ProjectileSpeedMul or 1))
		self:EmitSound("physics/metal/sawblade_stick3.wav", 70, 250)

		self.Bounces = self.Bounces + 1
	else
		self.HitData = data
	end

	self:NextThink(CurTime())
end

function ENT:TraceHits()
end

function ENT:Think()
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end
	local inflictor = self.ProjSource
	local pos = self:GetPos()
	local dmg = self.Damage
	local taperfactor = 0.9

	if self.DieTime <= CurTime() then
		self:Explode()
	end
	
	local phys = self:GetPhysicsObject()
	
	if self.DieTime >= CurTime() or not self.HitData then
		for _, ent in pairs(util.BlastAlloc(inflictor, owner, pos, 15 * (owner.ExpDamageRadiusMul or 1))) do
			if ent:IsValidLivingPlayer() and ent:IsValidLivingZombie() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) then
				ent:TakeSpecialDamage(dmg * (1 + self.DamageStored / 4), DMG_DROWN, owner, inflictor, ent:GetPos())
				ent:AddLegDamageExt(dmg * (self.DamageStored / 4), owner, self, SLOWTYPE_COLD)
				ent:AddArmDamage(4)
				ent:EmitSound("physics/metal/sawblade_stick3.wav", 100, 150)
				
				dmg = dmg * taperfactor
				self.DamageStored = self.DamageStored + 1
			end
		end
		
		if self.Homing then
			if self.Target and self.Target:IsValidLivingZombie() then
				local zombpos, speedmul = self.Target:GetPos(), math.min(pos:DistToSqr(self.Target:GetPos()) ^ 0.5, 250 * (owner.ProjectileSpeedMul or 1))
				zombpos.z = zombpos.z + 30
				phys:SetVelocityInstantaneous((zombpos - pos):GetNormalized() * speedmul+ self.Target:GetVelocity())
			else
				for _, zomb in pairs(ents.FindInSphere(pos, 250)) do
					if zomb:IsValidLivingPlayer() and zomb:IsValidLivingZombie() and gamemode.Call("PlayerShouldTakeDamage", zomb, owner) and WorldVisible(pos, zomb:GetShootPos()) then
						self.Target = zomb
						break
					end
				end
			end
		end
		
	else
		self:Explode()
	end
	
	self:NextThink(CurTime() + 0.1)
end

function ENT:OnRemove()
	self.WaveSound:Stop()
	--self.ProjSource:SetTumbler(false)
end

function ENT:ProcessHitEntity( ent )
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true
	local owner = self:GetOwner()
	local inflictor = self.ProjSource
	local devider = math.min(self.Damage + (self.Damage * self.DamageStored * 0.5), self.Damage * 10)
	
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(Vector(0,0,1))
	util.Effect("explosion_ice", effectdata)
	
	if owner:IsValidHuman() then
		util.BlastDamagePlayer(inflictor, owner, self:GetPos(), 100 * (owner.ExpDamageRadiusMul or 1), devider, DMG_DROWN, 0.9)
	end
	
	self:Remove()
end