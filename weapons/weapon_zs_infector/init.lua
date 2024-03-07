--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:ThrowHook()
	local owner = self:GetOwner()

	owner.LastRangedAttack = CurTime()

	local ent = ents.Create("projectile_kingcrab")
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

function SWEP:PoundAttackProcess()
	if CurTime() < self.PoundAttackStart + 0.4 then return end

	local owner = self:GetOwner()
	local pos = owner:GetPos() + Vector(0, 0, 2)

	owner:LagCompensation(true)

	

	owner:LagCompensation(false)
end
