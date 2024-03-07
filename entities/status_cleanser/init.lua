--[[SECURE]]--
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.Appliers = {}

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
	if self:GetStacks() <= 0 or owner:IsValidZombie() then
		self:Remove()
		return
	end

	for _, v in ipairs(GAMEMODE.ResistableStatuses) do
		local status = owner:GetStatus(v)
		if status and IsValid(status.Applier) then
			owner:RemoveStatus(v, false, true)
			owner.LastCleansing = CurTime() + 25

			local st = status:GetStartTime()
			local dur = status:GetDuration()
			local result = dur + (st - CurTime()) 

			local healer, _ = next( self.Appliers )
			if not healer then healer = owner end

			self:AddStacks(-1,healer)
			if (healer == owner) or healer:IsValidZombie() then break end
			if not healer:IsPlayer() then break end
			healer:AddPoints(0.25 * math.floor(result))
			break
		end
	end

	self:NextThink(CurTime() + 1)
	return true
end