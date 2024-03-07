--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.NextSurge = 0
SWEP.Surging = false

function SWEP:SubThink()
	local owner = self:GetOwner()
	if self.Surging then
		if self.SurgePos and self.SurgePos:Distance(owner:GetPos()) > 36 then
			
			if owner and owner:IsValid() then
				owner:SetLocalVelocity(owner:GetVelocity() * 0.1)
				owner:ResetSpeed()
			end
			self.Surging = false
			self.SurgePos = nil
		end
	end

	if owner:KeyPressed(IN_SPEED) and owner:OnGround() then
		if owner:KeyDown(IN_MOVERIGHT) then
			self:PerformDodge(owner:GetRight(), 1300) 
		elseif owner:KeyDown(IN_MOVELEFT) then
			self:PerformDodge(owner:GetRight(), -1300) 
		elseif owner:KeyDown(IN_BACK) then
			self:PerformDodge(owner:GetForward(), -1300) 
		elseif owner:KeyDown(IN_FORWARD) then
			self:PerformDodge(owner:GetForward(), 1300) 
		end
	end
end

function SWEP:PerformDodge(dir, force)
	local owner = self:GetOwner()
	if (owner:GetStamina() < 10) then return end
	if not owner:GetGroundEntity():IsValid() and not owner:GetGroundEntity():IsWorld() or owner:GetBarricadeGhosting() then return end

	self.NextSurge = CurTime() + 1

	owner:TakeStamina(10, 5)
	local ang = owner:GetAimVector()
	ang.z = 0

	if (owner:GetGroundEntity():IsValid() or owner:GetGroundEntity():IsWorld() or owner:WaterLevel() > 0) then
		local dir = dir or owner:GetForward()
		local force = force or 2500
		self.SurgePos = owner:GetPos()
		owner:SetLocalVelocity(dir * force)
		self.Surging = true
	end
end