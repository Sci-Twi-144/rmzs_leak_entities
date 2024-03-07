SWEP.PrintName = (translate.Get("wep_zipgun_boom"))
SWEP.Description = (translate.Get("desc_zipgun_boom"))

SWEP.Base = "weapon_zs_blareduct"

SWEP.Primary.Damage = 54
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5

SWEP.ConeMax = 7.5
SWEP.ConeMin = 6.5

SWEP.ReloadSpeed = 0.43
SWEP.ReloadDelay = 0.45

SWEP.ResistanceBypass = 0.6
SWEP.ClassicSpread = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.15, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RECOIL, -32.5)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -1)
