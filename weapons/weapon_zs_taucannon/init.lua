--[[SECURE]]--
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Primary.Projectile = "projectile_tauball_regular"
SWEP.Primary.ProjVelocity = 2500

function SWEP:ShootBall(damage)
	local owner = self:GetOwner()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	local recoil = 8

	local r = math.Rand(0.8, 1)
	owner:ViewPunch(Angle(r * -recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * recoil))

	local ent = ents.Create(self.Primary.Projectile)
	if ent:IsValid() then
		ent:SetPos(owner:GetShootPos())
		ent:SetAngles(owner:EyeAngles())
		ent:SetOwner(owner)
		ent.ProjDamage = damage * (owner.ProjectileDamageMul or 1)
		ent.ProjSource = self
		ent.ProjTaper = self.Primary.ProjExplosionTaper
		ent.Team = owner:Team()
		ent:Spawn()

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()

			local angle = owner:GetAimVector():Angle()
			ent.PreVel = angle:Forward() * self.Primary.ProjVelocity * (owner.ProjectileSpeedMul or 1)
			phys:SetVelocityInstantaneous(ent.PreVel)
		end
	end
end