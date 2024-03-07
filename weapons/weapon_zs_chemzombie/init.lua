--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.NextAura = 0
function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if self.NextAura <= CurTime() then
		self.NextAura = CurTime() + 2

		local origin = self:GetOwner():LocalToWorld(self:GetOwner():OBBCenter())
		for _, ent in pairs(util.BlastAlloc(self, self:GetOwner(), origin, 80)) do
			if ent:IsValidLivingHuman() then
				ent:PoisonDamage(1, self:GetOwner(), self)
			end
		end
	end
end
