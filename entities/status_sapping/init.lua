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
		if applier and applier:IsValidLivingHuman() --[[and applier ~= attacker]] and attacker:IsValidLivingHuman() and ent:IsValidLivingZombie() then

			local internal_cooldown = attacker.SapCooldown and attacker.SapCooldown > CurTime()
			if not internal_cooldown then
				applier:HealPlayer(attacker, 1 * (applier.MedicHealMul or 1), 1, true)
				attacker.SapCooldown = CurTime() + 1
			end
		end
	end)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("PlayerHurt", ENTC)
end