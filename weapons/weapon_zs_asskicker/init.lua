--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsValid() then
		local dir = ent:LocalToWorld(ent:OBBCenter()) - self:GetOwner():GetPos()
		dir.z = 0
		dir:Normalize()
		dir.z = 3.6 -- yes go to hell humains
		ent:SetVelocity(200 * dir)
		if ent:IsPlayer() then
			ent:KnockDown()
		end
		ent:SetGroundEntity(NULL)

		local noknockdown = true
		if CurTime() >= (ent.NextKnockdown or 0) then
			noknockdown = false
			ent.NextKnockdown = CurTime() + 4
		end
		ent:ThrowFromPositionSetZ(trace.StartPos, ent:IsPlayer() and 600 or 1600, nil, noknockdown)
	end
	
	-- if ent:IsPlayer() then
		-- ent:ApplyZombieDebuff("frightened", 4, {Applier = self:GetOwner()}, true, 39)
	-- end
	
	damage = damage + damage * GAMEMODE:GetWave()/7

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end
