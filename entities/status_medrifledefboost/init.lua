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

function ENT:CreateSVHook(enty)
	hook.Add("SpecialPlayerDamage", tostring(enty), function(ent, dmginfo)
		if not IsValid(self) then return end

		local attacker = dmginfo:GetAttacker()
		if ent ~= enty:GetOwner() then return end

		if attacker:IsValidZombie() then
			local protect = enty:GetDamage() or 0.3

			local dmgfraction = dmginfo:GetDamage() * protect
			dmginfo:SetDamage(dmginfo:GetDamage() * (1 - protect))

			local hpperpoint = GAMEMODE.MedkitPointsPerHealth
			local points = (dmgfraction / hpperpoint)

			if enty.Applier and enty.Applier:IsValidLivingHuman() then
				DefenceDamage[enty.Applier] = (DefenceDamage[enty.Applier] or 0) + dmgfraction
				enty.Applier:AddPoints(points)
			end
		end
	end)

	self:SetDTInt(1, 0)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("SpecialPlayerDamage", ENTC)
end
