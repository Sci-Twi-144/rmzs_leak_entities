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
			dmginfo:SetDamage(dmginfo:GetDamage() * (1 + 0.09 * enty:GetStacks()))
		end
	end)
	--hook.Add("HumanKilledZombie", tostring(ent), self_HumanKilledZombie) 

	self:SetStacks(0)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("SpecialPlayerDamage", ENTC)
end

--[[ lol wtf
function ENT:HumanKilledZombie(pl, attacker, inflictor, dmginfo, headshot, suicide)
	if attacker ~= self:GetOwner() then return end

	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		local reaperstatus = attacker:GiveStatus("reaper", math.min(14, self.DieTime - CurTime() + 7))
		if reaperstatus and reaperstatus:IsValid() then
			attacker:EmitSound("hl1/ambience/particle_suck1.wav", 55, 150 + reaperstatus:GetDTInt(1) * 30, 0.45)
		end
	end
end
]]