ENT.Base = "prop_gunturret"

ENT.SWEP = "weapon_zs_gunturret_rocket"

ENT.AmmoType = "impactmine"
ENT.FireDelay = 2
ENT.NumShots = 1
ENT.Damage = 97
ENT.PlayLoopingShootSound = false
ENT.Spread = 0.75
ENT.MaxAmmo = 30
ENT.MaxHealth = 225

function ENT:PlayShootSound()
	self:EmitSound("weapons/stinger_fire1.wav", 80, math.random(148, 153), 0.8)
	self:EmitSound("weapons/grenade_launcher1.wav", 80, math.random(86, 92), 0.7, CHAN_WEAPON + 20)
end

function ENT:IsValidTarget(target)
	return target:IsPlayer() and target:Team() == TEAM_UNDEAD and target:Alive() and not target:GetZombieClassTable().NoTurretTarget and not target:IsHeadcrab() and not target:GetStatus("zombiespawnbuff")
	and self:GetForward():Dot(self:GetAnglesToTarget(target):Forward()) >= self.MinimumAimDot
	and TrueVisibleFilters(self:ShootPos(), self:GetTargetPos(target), self, self.Hitbox)
end