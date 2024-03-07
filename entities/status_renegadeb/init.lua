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

function ENT:Processing()
	timer.Simple(0, function()
		local owner = self:GetOwner()
		local stacks = self:GetStacks()
		local mystacks = owner.RenegadeStacks 
		local adds = owner:GetStatus("renegade") and owner:GetStatus("renegade"):GetStacks() or 0
		owner.RenegadeStacks = math.min(stacks + mystacks, (adds + (owner.ReaperStackValExtra or 0)) + (owner.ReaperStackVal or 1) or 1)
	end)
end

function ENT:CreateSVHook(enty)

	hook.Add("SpecialPlayerDamage", tostring(enty), function(ent, dmginfo)
		if not IsValid(self) then return end
		
		local attacker = dmginfo:GetAttacker()
		if attacker ~= enty:GetOwner() then return end
		if attacker:IsValidLivingHuman() then
			dmginfo:SetDamage(dmginfo:GetDamage() / GAMEMODE:GetZombieDamageScale(dmginfo:GetDamagePosition(), ent))
		end
	end)

	self:SetStacks(0)
end

function ENT:RemoveSVHook(ENTC)
	local owner = self:GetOwner()
	local adds = owner:GetStatus("renegade") and owner:GetStatus("renegade"):GetStacks() or 0
	owner.RenegadeStacks = math.max(adds, 0)
	hook.Remove("SpecialPlayerDamage", ENTC)
end