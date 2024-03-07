--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Think()
	local fCurTime = CurTime()
	local owner = self:GetOwner()

	if owner:IsValid() then
		if self:GetStateEndTime() <= fCurTime and self:GetState() == 1 or not owner:Alive() or owner:GetZombieClassTable().Name ~= "Frost Shade" or self.Destroyed then
			local extraduration = (1 - self:GetObjectHealth()/self:GetMaxObjectHealth()) * 10
			owner.NextShield = fCurTime + (self.Destroyed and 12 or (2 + extraduration))

			if owner:IsValidLivingZombie()  then
				local wep = owner:GetActiveWeapon()
				local SCD = owner.NextShield - fCurTime
				wep:SetAbstractNumber(SCD)
				wep:SetResource(SCD, true)
			end

			self:Remove()
			return
		elseif self:GetStateEndTime() <= fCurTime and self:GetState() == 0 and not self.Constructed then
			self:PhysicsInit(SOLID_VPHYSICS)

			local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(false)
			end

			self:EmitSound("physics/glass/glass_impact_bullet3.wav", 70, 75)
			self.Constructed = true
		end

		if self:GetState() == 1 and self.Constructed then
			self:PhysicsInit(SOLID_NONE)
			self:EmitSound("physics/glass/glass_pottery_break4.wav", 70, 110)

			self.Constructed = false
		end

		if fCurTime >= self.NextHeal and self.DamageTaken ~= 150 then
			self.NextHeal = fCurTime + 0.4

			if self:GetObjectHealth() < self:GetMaxObjectHealth() then
				self:SetObjectHealth(math.min(self:GetObjectHealth() + 15, self:GetMaxObjectHealth()))
			end
		end

		if fCurTime >= self.NextDamageSet then
			self.NextDamageSet = fCurTime + 1
			self.DamageTaken = 0
		end

		self:SetPos(LerpVector(0.75, self:GetPos(), owner:GetPos() + owner:GetForward() * 40))
		local angs = owner:GetAngles()
		angs:RotateAroundAxis(self:GetUp(), 135)
		local entangle = self:GetAngles()
		entangle.p = 0
		entangle.r = 0

		self:SetAngles(LerpAngle(0.75, entangle, angs))
	else
		self:Remove()
	end

	self:NextThink(fCurTime)
	return true
end
