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

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local enty = self
	self:CreateSVHook(enty)

	self:SetDTInt(1, 0)
end

function ENT:CreateSVHook(enty)
	hook.Add("SpecialPlayerDamage", tostring(enty), function(ent, dmginfo)
		if not IsValid(self) then return end
		if ent ~= enty:GetOwner() then return end
		

		local applier = enty.Applier
		local attacker = dmginfo:GetAttacker()
		
		local healstrength = self.Repair * (applier.RepairRateMul or 1)
		local oldhealth = applier:GetBarricadeHealth()
		
		if applier and attacker:IsNailed() and attacker:IsValidLivingZombie() then

			local internal_cooldown = attacker.SapCooldown and attacker.SapCooldown > CurTime()
			if not internal_cooldown then
				if oldhealth <= 0 or oldhealth >= applier:GetMaxBarricadeHealth() or applier:GetBarricadeRepairs() <= 0.01 then return end
				applier:SetBarricadeHealth(math.min(applier:GetMaxBarricadeHealth(), applier:GetBarricadeHealth() + math.min(applier:GetBarricadeRepairs(), healstrength2)))
				local healed = applier:GetBarricadeHealth() - oldhealth
				applier:SetBarricadeRepairs(math.max(applier:GetBarricadeRepairs() - healed, 0))
				attacker.SapCooldown = CurTime() + 1
			end
		end
	end)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("PlayerHurt", ENTC)
end