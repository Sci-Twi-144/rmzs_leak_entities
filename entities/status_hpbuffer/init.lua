--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
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
--[[
function ENT:CreateSVHook(enty)
	hook.Add("PlayerHurt", tostring(enty), function(victim, attacker, healthleft, damage)
		if not IsValid(self) then return end
		if victim ~= enty:GetOwner() then return end

		local applier = enty.Applier
		if applier and applier:IsValidLivingZombie() and applier ~= attacker and attacker:IsValidLivingZombie() and victim:IsValidLivingHuman() then
			local attributeddamage = damage
			if healthleft < 0 then
				attributeddamage = attributeddamage + healthleft
			end

			if playertbl.HpBuffered and not dmgbypass then
				local hpbuffer = enty
				if hpbuffer:GetMagnitude() > 0 then
					local dmgbuffer = math.min(hpbuffer:GetMagnitude(), dmginfo:GetDamage())
				--	print(dmgbuffer)
					dmginfo:SetDamage(dmginfo:GetDamage() - dmgbuffer)
					hpbuffer:SetMagnitude(hpbuffer:GetMagnitude() - dmgbuffer)
				end
			end

			applier:HealPlayer(attacker, 1 * (applier.MedicHealMul or 1), 1, true)
		end
	end)
end
]]
function ENT:CreateSVHook(enty)
	hook.Add("SpecialPlayerDamage", tostring(enty), function(ent, dmginfo)
		if not IsValid(self) then return end
		local owner = enty:GetOwner()
		local attacker = dmginfo:GetAttacker()
		--if attacker ~= enty:GetOwner() then return end

		if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
			local hpbuffer = enty

			local applier, _ = next( enty.Appliers )
			--if not applier then applier = owner end

			local dmgbuffer = math.min(hpbuffer:GetMagnitude(), dmginfo:GetDamage())
			--timer.Simple(0, function()
				PrintTable(enty.Appliers)
				print(applier)
				local points = dmgbuffer / dmginfo:GetDamage() * 10
				applier:AddPoints(points)
				dmginfo:SetDamage(dmginfo:GetDamage() - dmgbuffer)
				hpbuffer:UpdateMagnitude(applier, -dmgbuffer)
			--end)
		end

	end)

	self:SetMagnitude(0)
end


function ENT:RemoveSVHook(ENTC)
	hook.Remove("PlayerHurt", ENTC)
end
--[[
function ENT:Think()
	local owner = self:GetOwner()

	if self:GetMagnitude() <= 0 or owner:Team() == TEAM_UNDEAD then
		
		self:Remove()
		return
	end

	self:NextThink(CurTime() + 1)
	return true
end
]]