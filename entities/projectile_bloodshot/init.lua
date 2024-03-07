--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/labpart.mdl")
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.42, 0)
	self:SetCustomCollisionCheck(true)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(1)
		phys:SetBuoyancyRatio(0.01)
		phys:SetDamping(1.5, 4)
		phys:EnableDrag(false)
		phys:Wake()
	end
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal)
	end
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end

function ENT:Explode(hitpos, hitnormal)
	if self.Exploded then return end
	self.Exploded = true

	self:Fire("kill", "", 0.01)

	local owner = self:GetOwner()

	hitpos = hitpos or self:GetPos()
	if not hitnormal then
		hitnormal = self:GetVelocity():GetNormalized() * -1
	end

	if owner:IsValidLivingHuman() then
		for _, ent in pairs(util.BlastAlloc(self, owner, hitpos, self.Radius * (owner.CloudRadius or 1))) do
			if ent:IsValidLivingHuman() then
				ent:SetBloodArmor(math.min(ent:GetBloodArmor() + 10 * (ent.BloodarmorGainMul or 1), (ent.MaxBloodArmor or 10)))

				local strght = {Applier = owner, Damage = (0.4 * (owner.BuffEffectiveness or 1))} 
				local prot = {Applier = owner, Damage = 0.3 * (owner.BuffEffectiveness or 1)}
				ent:ApplyHumanBuff("strengthdartboost", 10 * (owner.BuffDuration or 1), strght)
				ent:ApplyHumanBuff("medrifledefboost", 8 * (owner.BuffDuration or 1), prot)

				net.Start("zs_buffby")
					net.WriteEntity(owner)
					net.WriteString("Bloodshot Bomb")
				net.Send(ent)
			end
		end
	end

	self:NextThink(CurTime())
end
