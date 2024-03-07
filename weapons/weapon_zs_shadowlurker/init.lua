--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsPlayer() then
		ent:ApplyZombieDebuff("dimvision", 5, {Applier = self:GetOwner()}, true, 7)
		ent:ApplyZombieDebuff("anchor", 2, {Applier = self:GetOwner()}, true, 34)
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end
