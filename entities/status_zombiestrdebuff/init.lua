--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local enty = self
	hook.Add("SpecialPlayerDamage", tostring(enty), function(ent, dmginfo)
		if not IsValid(self) then return end
		
		if ent ~= enty:GetOwner() then return end
	
		local attacker = dmginfo:GetAttacker()
		if attacker:IsValidHuman() then
			local plywep = rawget(PLAYER_GetWeaponActive, attacker)
			local tier = plywep.Tier or 1
			local div = math.max(tier * 0.35, 1)
			local bdmg = math.max(0, (enty:GetDamage() or 0.25) / div) 
			dmginfo:SetDamage(dmginfo:GetDamage() * (1 + bdmg) or 1.25)
		end
	end)

	self:CreateSVHook(enty)

	self:SetDTInt(1, 0)
end

function ENT:CreateSVHook(enty)
	hook.Add("PlayerHurt", tostring(enty), function(victim, attacker, healthleft, damage)
		if not IsValid(self) then return end
		if victim ~= enty:GetOwner() then return end

		local applier = enty.Applier
		if applier and applier:IsValidLivingHuman() and applier ~= attacker and attacker:IsValidLivingHuman() and victim:IsValidLivingZombie() then
			local attributeddamage = damage
			if healthleft < 0 then
				attributeddamage = attributeddamage + healthleft
			end

			if attributeddamage > 0 then
				local plywep = rawget(PLAYER_GetWeaponActive, attacker)
				local tier = plywep.Tier or 1
				local div = math.max(tier * 0.35, 1)
				local bdmg = math.max(0, (enty:GetDamage() or 0.25) / div)
				attributeddamage = attributeddamage - (attributeddamage / ((1 + bdmg) or 1.25))

				DamageDealt[applier][TEAM_HUMAN] = DamageDealt[applier][TEAM_HUMAN] + attributeddamage
				DamagedBy[victim][applier] = (DamagedBy[victim][applier] or 0) + attributeddamage

				local points = attributeddamage / victim:GetMaxHealth() * victim:GetZombiePointGain()
				PointQueue[applier] = PointQueue[applier] + points

				local pos = victim:GetPos()
				pos.z = pos.z + 32
				LastDamageDealtPos[applier] = pos
				LastDamageDealtTime[applier] = CurTime()
			end
		end
	end)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("PlayerHurt", ENTC)
end