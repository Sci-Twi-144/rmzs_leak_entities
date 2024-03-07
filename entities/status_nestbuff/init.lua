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

function ENT:CreateSVHook(ENTC, enty)
	hook.Add("SpecialPlayerDamage", ENTC, function(ent, dmginfo)
		if not IsValid(self) then return end
		
		local attacker = dmginfo:GetAttacker()
		if enty:GetUpDMG() then
			if (attacker == enty:GetOwner()) and attacker:IsValidLivingZombie() then
				local dmg = dmginfo:GetDamage()
				local extradamage = dmg * 0.15
				dmginfo:SetDamage(dmg + extradamage)
			end
		end

		if enty:GetUpResist() then -- я не ебу но через elseif оно не работает тут
			if (ent == enty:GetOwner()) and attacker:IsValidLivingHuman() then
				local dmg = dmginfo:GetDamage()
				local reduceddmg = dmg * 0.1
				dmginfo:SetDamage(dmg - reduceddmg)
			end
		end
	end)

	self:SetDTInt(1, 0)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("SpecialPlayerDamage", ENTC)
end

function ENT:Think()
	local owner = self:GetOwner()
	if self.DieTime <= CurTime() or not (owner:IsValidLivingZombie() and not owner:GetZombieClassTable().Boss) then self:Remove() end
end