SWEP.PrintName = (translate.Get("wep_proxymine"))
SWEP.Description = (translate.Get("desc_proxymine"))

SWEP.Base = "weapon_zs_basethrown"

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.Ammo = "betty"

SWEP.MaxStock = 8

SWEP.Primary.Damage = 235
SWEP.Primary.ProjExplosionRadius = 335
SWEP.Primary.ProjExplosionTaper = 0.85

function SWEP:PrimaryAttack()
	self.BaseClass.PrimaryAttack(self)
	self:SendWeaponAnimation()
end