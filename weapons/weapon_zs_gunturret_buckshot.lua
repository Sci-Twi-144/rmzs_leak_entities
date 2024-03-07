AddCSLuaFile()

SWEP.Base = "weapon_zs_gunturretbase"

SWEP.PrintName = (translate.Get("wep_gunturret_buckshot"))
SWEP.Description = (translate.Get("desc_gunturret_buckshot"))

SWEP.Primary.Damage = 6.8
SWEP.Primary.NumShots = 7

SWEP.GhostStatus = "ghost_gunturret_buckshot"
SWEP.DeployClass = "prop_gunturret"
SWEP.TurretAmmoType = "buckshot"
SWEP.TurretAmmoStartAmount = 25
SWEP.TurretSpread = 5
SWEP.HeatBuildShort = 0.1

SWEP.SearchDistance = 225
SWEP.TurretType = 2
SWEP.Primary.Ammo = "turret_buckshot"

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.9)
