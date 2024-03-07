--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + 30

	self:SetModel("models/props_junk/rock001a.mdl")
	self:SetModelScale(0.5)
	self:SetMaterial("models/shadertest/shader2")
	self:SetColor(Color(30, 150, 255, 255))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetTrigger(true)
	self:SetupGenericProjectile(true)
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal)
	end

	if self.DieTime <= CurTime() then
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed >= 50 then
		self.PhysicsData = data
		self:NextThink(CurTime())
	end
end

function ENT:StartTouch(ent)
	if self.DieTime ~= 0 and ent:IsValidLivingPlayer() then
		local owner = self:GetOwner()
		if not owner:IsValid() then owner = self end

		if ent ~= owner and ent:Team() ~= self.Team then
			ent:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav")
			ent:TakeSpecialDamage(self.ProjDamage or 36, DMG_CLUB, owner, self, nil)
			self:Explode()
		end
	end
end

function ENT:Explode(hitpos, hitnormal)
	if self.DieTime == 0 then return end
	self.DieTime = 0

	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or (self:GetVelocity():GetNormalized() * -1)

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetNormal(hitnormal)
	util.Effect("hit_ice_small", effectdata)

	self:NextThink(CurTime())
end
