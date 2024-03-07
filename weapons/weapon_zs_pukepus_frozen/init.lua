--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Think()
	local pl = self:GetOwner()

	if self.PukeLeft > 0 and CurTime() >= self.NextPuke then
		self.PukeLeft = self.PukeLeft - 1
		self.NextEmit = CurTime() + 0.2
		pl.LastRangedAttack = CurTime()

		local ent = ents.Create(self.PukeLeft % 3 == 1 and "projectile_ghoulfleshpuke_fr" or "projectile_poisonpuke")
		if ent:IsValid() then
			ent:SetPos(pl:EyePos())
			ent:SetOwner(pl)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				local ang = pl:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-15, 15))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-30, 30))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(450, 600))
			end
		end
	end

	self:NextThink(CurTime())
	return true
end
