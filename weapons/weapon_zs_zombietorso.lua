AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Zombie Torso"

SWEP.MeleeDelay = 0.25
SWEP.MeleeReach = 40
SWEP.MeleeDamage = 25
SWEP.SwingAnimSpeed = 2.96

SWEP.DelayWhenDeployed = true

function SWEP:Reload()
	self:SecondaryAttack()
end