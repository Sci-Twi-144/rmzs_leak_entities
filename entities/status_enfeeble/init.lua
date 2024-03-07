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

function ENT:CreateSVHook(ENTC)
	local enty = self

	hook.Add("SpecialPlayerDamage", ENTC, function(ent, dmginfo)
		if not IsValid(enty) then return end

		if ent ~= enty:GetOwner() then return end

		local attacker = dmginfo:GetAttacker()
		if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
			dmginfo:SetDamage(dmginfo:GetDamage() * (enty.DamageScale + 0.1 * enty:GetStacks()))
		end
	end)

	hook.Add("PlayerHurt", ENTC, function(victim, attacker, healthleft, damage)
		if not IsValid(enty) then return end

		if enty.Applier and enty.Applier:IsValidLivingZombie() and enty.Applier ~= attacker and victim:IsValidLivingHuman() then
			local attributeddamage = damage
			if healthleft < 0 then
				attributeddamage = attributeddamage + healthleft
			end

			if attributeddamage > 0 then
				attributeddamage = attributeddamage - (attributeddamage / (enty.DamageScale + 0.1 * enty:GetStacks()))

				DamageDealt[enty.Applier][TEAM_UNDEAD] = DamageDealt[enty.Applier][TEAM_UNDEAD] + attributeddamage
				enty.Applier:AddLifeHumanDamage(attributeddamage)
			end
		end
	end)

	self:EmitSound("beams/beamstart5.wav", 65, 140)
	self:SetStacks(0)
end

function ENT:RemoveSVHook(ENTC)
	self:SetStacks(0)
	hook.Remove("SpecialPlayerDamage", ENTC)
	hook.Remove("PlayerHurt", ENTC)
end