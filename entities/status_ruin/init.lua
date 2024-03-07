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
	hook.Add("EntityTakeDamage", tostring(enty), function(ent, dmginfo)
		if not IsValid(self) then return end
		
		local attacker = dmginfo:GetAttacker()
	
		if attacker:IsValidLivingZombie() and enty:GetDTEntity(0) == ent then
			local dmg = dmginfo:GetDamage()
			local extradamage = dmg * 0.25
			dmginfo:SetDamage(dmg + extradamage)
			if enty.Applier and enty.Applier:IsValidLivingZombie() then
				enty.Applier:AddLifeBarricadeDamage(extradamage)
			end
		end
	end)

	self:SetDTInt(1, 0)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("EntityTakeDamage", ENTC)
end

--[[
function ENT:CreateSVHook(enty)
	hook.Add("OnNailDebuff", tostring(enty), function(ent, attacker, inflictor, damage, dmginfo)
		print("got that bitch", ent)

	end)
end

function ENT:RemoveSVHook(ENTC)
	print("end")
	hook.Remove("OnNailDebuff", ENTC)
end
]]