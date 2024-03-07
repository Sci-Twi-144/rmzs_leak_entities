AddCSLuaFile()

SWEP.Base = "weapon_zs_gunturretbase"

SWEP.PrintName = (translate.Get("wep_gunturret_assault"))
SWEP.Description = (translate.Get("desc_gunturret_assault"))

SWEP.Primary.Damage = 28

SWEP.GhostStatus = "ghost_gunturret_assault"
SWEP.DeployClass = "prop_gunturret"

SWEP.TurretAmmoType = "ar2"
SWEP.TurretAmmoStartAmount = 100
SWEP.TurretSpread = 2
SWEP.HeatBuildShort = 0.015

SWEP.TurretType = 3
SWEP.Tier = 4

SWEP.Primary.Ammo = "turret_assault"

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.5)
