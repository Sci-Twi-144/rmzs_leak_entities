--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:BotAttackMode( enemy )
	if (enemy:GetPos():DistToSqr(self:GetOwner():GetPos())>160000 or not enemy.KnockedDown) then -- Square(400)
		return 1
	else
		return 0
	end
end

function SWEP:ThrowHook()
	local owner = self:GetOwner()

	owner.LastRangedAttack = CurTime()

	local ent = ents.Create("projectile_devourer")
	if ent:IsValid() then
		local ang = owner:EyeAngles()
		ang:RotateAroundAxis(ang:Up(), 90)

		ent:SetPos(owner:GetShootPos())
		ent:SetAngles(ang)
		ent:SetOwner(owner)
		ent:Spawn()

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocityInstantaneous(owner:GetAimVector() * 2400)
		end
	end
end
