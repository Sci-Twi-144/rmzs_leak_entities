SWEP.PrintName = (translate.Get("wep_grenade"))
SWEP.Description = (translate.Get("desc_grenade"))

SWEP.Base = "weapon_zs_basethrown"

SWEP.MaxStock = 8

SWEP.Primary.Damage = 256
SWEP.Primary.ProjExplosionRadius = 256

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_THROW)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end