--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:ShootGrenade(damage, numshots, cone)
	local owner = self:GetOwner()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	local recoil = 8

	local r = math.Rand(0.8, 1)
	owner:ViewPunch(Angle(r * -recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * recoil))

	local damage = damage * 6.2

	local ent = ents.Create(self.Primary.Projectile)
	if ent:IsValid() then
		ent:SetPos(owner:GetShootPos())
		--local obj = self:GetBonePosition(23) --4 23 53 73
		--ent:SetPos(obj + Vector(2, 7, 0)) -- + Vector(-1, 5, 3)
		ent:SetAngles(owner:EyeAngles())
		ent:SetOwner(owner)
		ent.ProjDamage = damage * (owner.ProjectileDamageMul or 1)
		ent.ProjSource = self
		ent.ProjTaper = self.Primary.ProjExplosionTaper
		ent.ProjRadius = self.Primary.ProjExplosionRadius
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

function SWEP:EntModify(ent)
	ent.ProjRadius = self.Primary.ProjExplosionRadius
	ent.ProjTaper = self.Primary.ProjExplosionTaper
end
