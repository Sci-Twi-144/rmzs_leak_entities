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

function ENT:Think()
	local owner = self:GetOwner()

	if owner:GetStatus("shockdebuff") then
		self:Remove()
		return
	end

	if self.DieTime <= CurTime() then
		self:Remove()
	end

	self:NextThink(CurTime() + 0.1)
	return true
end
