--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_arrow_cha"
ENT.HitOneTime = true
ENT.MaxHitCounts = 1

ENT.SubProjectile = "projectile_flak"
ENT.SubCallback = function(ent) end

function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetModelScale(0.55, 0)
	self:SetTrigger(true)
	self:SetupGenericProjectile(true)
	self:EmitSound("weapons/crossbow/bolt_fly4.wav", 75, 125)
end

function ENT:Explode(hitpos, hitnormal)
	if self.Exploded then return end
	self.Exploded = true

	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or self:GetForward()
	
	hitnormal = hitnormal or Vector(0, 0, 0)
	local upmulti = hitent and 1 or math.Clamp(-hitnormal.z, 0, 1)

	local owner = self:GetOwner()
	if owner:IsValidLivingHuman() then
		local source = self:ProjectileDamageSource()

		util.BlastDamagePlayer(source, owner, hitpos, 56 * (owner.ExpDamageRadiusMul or 1), self.ProjDamage * 0.4, DMG_ALWAYSGIB, 0.95)
	end
	
	for i = 0, 2 do
		local ent = ents.Create(self.SubProjectile)
		if ent:IsValid() then
			ent:SetPos(self:GetPos() - hitnormal * 12 * upmulti)
			ent:SetAngles(self:GetAngles())
			ent:SetOwner(owner)
			ent.ProjDamage = (self.ProjDamage * 0.33) * (owner.ProjectileDamageMul or 1)
			ent.ProjSource = self.ProjSource
			ent.Team = self.Team

			self.SubCallback(ent)

			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()

				local angle = Angle(0, 0, 0)
				angle:RotateAroundAxis(angle:Up(), math.random(360))
				phys:SetVelocityInstantaneous(angle:Forward() * 175 + Vector(0, 0, 200) * upmulti - hitnormal * 90)
			end
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(hitnormal)
	util.Effect("HelicopterMegaBomb", effectdata)
	self:EmitSound(")weapons/explode3.wav", 80, 180)
end

function ENT:ProcessHitWall()
	self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal)
	self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 100, 240, 0.7, CHAN_AUTO)
	self.Done = true
	self:Remove()
end

function ENT:ProcessHitEntity( ent )
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	self:Explode()
	self.Done = true
	self:Remove()
end
