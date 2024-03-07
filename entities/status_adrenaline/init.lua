--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:SetDie(fTime)
	if fTime == 0 or not fTime then
		self.DieTime = 0
	elseif fTime == -1 then
		self.DieTime = 999999999
	else
		self.DieTime = CurTime() + fTime
		self:SetDuration(fTime)
	end
end

function ENT:Processing()--
	timer.Simple(0, function()
		local owner = self:GetOwner()
		owner.ReloadSpeedMultiplier = 0
		owner.MeleeSwingDelayMul = 0
		owner.LowHealthSlowMul = 0
		owner.StaminaConsumptionMul = 0
		self:GetOwner():ApplyTrinkets()
		owner.ReloadSpeedMultiplier = owner.ReloadSpeedMultiplier + 0.15
		owner.MeleeSwingDelayMul = owner.MeleeSwingDelayMul - 0.15
		owner.LowHealthSlowMul = 0
		owner.StaminaConsumptionMul = 0.5
	end)
end

function ENT:CreateSVHook(enty)
--	self:SetStacks(0)
end

function ENT:RemoveSVHook(ENTC)
	self:GetOwner():ApplyTrinkets()
end