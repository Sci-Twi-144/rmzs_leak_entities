AddCSLuaFile()

SWEP.Base = "weapon_zs_gunturretbase"

SWEP.PrintName = (translate.Get("wep_gunturret_rocket"))
SWEP.Description = (translate.Get("desc_gunturret_rocket"))

SWEP.Primary.Damage = 104

SWEP.GhostStatus = "ghost_gunturret_rocket"
SWEP.DeployClass = "prop_gunturret"
SWEP.TurretAmmoType = "impactmine"
SWEP.TurretAmmoStartAmount = 12
SWEP.TurretSpread = 1
SWEP.HeatBuildShort = 0.1
SWEP.ProjExplosionTaper = 0.85

SWEP.Primary.Ammo = "turret_rocket"

SWEP.TurretType = 4
SWEP.Tier = 4

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.45)
