AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Fresh Dead"

SWEP.MeleeDamage = 20

function SWEP:Reload()
	self:SecondaryAttack()
end