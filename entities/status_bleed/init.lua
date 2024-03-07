--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.Bleed = self
end

function ENT:Think()
	local owner = self:GetOwner()

	if self:GetDamage() <= 0 then
		self:Remove()
		return
	end

	local dmg = math.Clamp(self:GetDamage(), 1, 2)

	owner:TakeDamage(dmg, self.Damager and self.Damager:IsValid() and self.Damager:IsPlayer() and self.Damager:Team() ~= owner:Team() and self.Damager or owner, self)
	self:AddDamage(-dmg)

	if self.Damager:IsValid() and (self:GetType() == 1) and (self.Damager ~= owner) then
		self.Damager:SetHealth(math.min(self.Damager:GetMaxHealthEx(), self.Damager:Health() + dmg * 5))
	end

	local dir = VectorRand()
	dir:Normalize()
	util.Blood(owner:WorldSpaceCenter(), 3, dir, 32)

	local moving = owner:GetVelocity():LengthSqr() >= 19600 --140^2
	local ticktime = (moving and (1/math.max(1,self:GetDamage()/7.5)) or 1)/(owner.BleedSpeedMul or 1)
	self:NextThink(CurTime() + ticktime)
	return true
end
