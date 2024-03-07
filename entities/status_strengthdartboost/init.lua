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
		if attacker ~= enty:GetOwner() then return end
	
		if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
			local plywep = rawget(PLAYER_GetWeaponActive, attacker)
			local tier = plywep.Tier or 1
			local div = math.max(tier * 0.35, 1)
			local bdmg = math.max(0, (enty:GetDamage() or 0.25) / div)

			local dmg = dmginfo:GetDamage()
			local extradamage = dmg * (bdmg or 0.25)
			dmginfo:SetDamage(dmg + extradamage)
	
			if enty.Applier and enty.Applier:IsValidLivingHuman() and ent:IsPlayer() and ent:Team() == TEAM_ZOMBIE then
				local applier = enty.Applier
				local cappeddamage = 0
				local zhp = ent:Health()
				if (zhp < (dmg + extradamage)) and (zhp > dmg) then
				    cappeddamage = zhp - dmg
				elseif zhp > (dmg + extradamage) then
				    cappeddamage = extradamage
				end
	
				DamagedBy[ent][applier] = (DamagedBy[ent][applier] or 0) + cappeddamage
				StrengthBoostDamage[applier] = (StrengthBoostDamage[applier] or 0) + cappeddamage
				local points = cappeddamage / ent:GetMaxHealth() * ent:GetZombiePointGain()
				PointQueue[applier] = PointQueue[applier] + points * 1.5
	
				local pos = ent:GetPos()
				pos.z = pos.z + 32
				LastDamageDealtPos[applier] = pos
				LastDamageDealtTime[applier] = CurTime()
			end
		end
	end)

	self:SetDTInt(1, 0)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("SpecialPlayerDamage", ENTC)
end
