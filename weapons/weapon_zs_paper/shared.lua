SWEP.PrintName = (translate.Get("wep_paper"))
SWEP.Description = (translate.Get("desc_paper"))

SWEP.Base = "weapon_zs_basethrown"

SWEP.ViewModel = "models/weapons/c_bugbait.mdl"
SWEP.WorldModel = "models/props/cs_office/paper_towels.mdl"

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.Ammo = "BuckshotHL1"

SWEP.MaxStock = 8

SWEP.Primary.Damage = 235
SWEP.Primary.ProjExplosionRadius = 335
SWEP.Primary.ProjExplosionTaper = 0.85

function SWEP:PrimaryAttack()
	self.BaseClass.PrimaryAttack(self)
	self:SendWeaponAnimation()
end