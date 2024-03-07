--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsPlayer() then
		local owner = self:GetOwner()
		--ent:ApplyZombieDebuff("frost", 8, {Applier = owner}, true, 10)
		ent:ApplyZombieDebuff("dimvision", 6, {Applier = owner}, true, 7)

		ent:AddLegDamageExt(25, owner, self, SLOWTYPE_COLD)
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end
