--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/combine_helicopter/helicopter_bomb01.mdl"

ENT.LifeSpan = 3
ENT.HitOneTime = true
ENT.MaxHitCounts = 1

ENT.SubProjectile = "projectile_flak"
ENT.SubCallback = function(ent) end

function ENT:InitProjectile()
	self:SetColor(Color(205, 135, 110))
	self:PhysicsInitSphere(4)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.33, 0)
	self:DrawShadow(false)
	self:SetTrigger(true)
	self:SetupGenericProjectile(true)

	self.ExplodeTime = CurTime() + self.LifeSpan
end

function ENT:Think()
	if self.ExplodeTime <= CurTime() then
		self:Explode(self:GetPos())
	end

	if self.PhysicsData then
		self:ProcessHitWall()
	end

	self:NextThink(CurTime())
	return true
end

function ENT:ProcessHitWall()
	self:Explode(self:GetPos(), self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
end

function ENT:ProcessHitEntity(ent)
	self:Explode(self:GetPos(), self:GetForward(), ent)
end

function ENT:Explode(hitpos, hitnormal, hitent)
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	hitnormal = hitnormal or Vector(0, 0, 1)
	local upmulti = hitent and 1 or math.Clamp(-hitnormal.z, 0, 1)

	if owner:IsValidLivingHuman() then
		local source = self:ProjectileDamageSource()
		util.BlastDamagePlayer(source, owner, hitpos, 81, (self.ProjDamage or 27) * 6, DMG_ALWAYSGIB, 0.7)
	end

	for i = 0, 6 do
		local ent = ents.Create(self.SubProjectile)
		if ent:IsValid() then
			ent:SetPos(self:GetPos() - hitnormal * 12 * upmulti)
			ent:SetAngles(self:GetAngles())
			ent:SetOwner(owner)
			ent.ProjDamage = self.ProjDamage * (owner.ProjectileDamageMul or 1)
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

	self:EmitSound(")weapons/explode5.wav", 80, 110)
	self:Remove()
end
