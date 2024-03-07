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
	---	print(enty:GetOwner())
		local attacker = dmginfo:GetAttacker()
		if attacker ~= enty:GetOwner() then return end
		if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
			dmginfo:SetDamage(dmginfo:GetDamage() * (1 + 0.075 * enty:GetStacks()))
		end
	end)
	--print(self:GetStacks())
	timer.Simple(0, function()
		local owner = self:GetOwner()
		owner.ReloadSpeedMultiplier = owner.ReloadSpeedMultiplier + (0.09 * self:GetStacks())
	end)

	self:SetStacks(0)
end

function ENT:RemoveSVHook(ENTC)
	self:GetOwner():ApplyTrinkets() -- вообще не важно, просто для сброса статов тут используем.
	hook.Remove("SpecialPlayerDamage", ENTC)
end