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
	
		if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and ent:Team() == TEAM_ZOMBIE then
			local dmg = dmginfo:GetDamage()
			local dmgtobounty = math.ceil(dmg * (enty:GetDamage() or 0.25))
			
			attacker:AddAccuBounty(dmgtobounty)
			attacker:BountyRecieve(attacker)
	
			if enty.Applier and enty.Applier:IsValidLivingHuman() and ent:IsPlayer() then
				local applier = enty.Applier
				
				applier:AddAccuBounty(dmgtobounty * 0.5)
				applier:BountyRecieve(applier)

			end
		end
	end)

	self:SetDTInt(1, 0)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("SpecialPlayerDamage", ENTC)
end