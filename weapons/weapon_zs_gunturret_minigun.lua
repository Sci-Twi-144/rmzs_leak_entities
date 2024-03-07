AddCSLuaFile()

SWEP.Base = "weapon_zs_gunturretbase"

SWEP.PrintName = (translate.Get("wep_gunturret_mini"))
SWEP.Description = (translate.Get("desc_gunturret_mini"))

SWEP.Primary.Damage = 18

SWEP.GhostStatus = "ghost_gunturret_minigun"
SWEP.DeployClass = "prop_gunturret"
SWEP.TurretAmmoType = "smg1"
SWEP.TurretAmmoStartAmount = 400
SWEP.TurretSpread = 3
SWEP.HeatBuildShort = 0.0075

SWEP.Primary.Ammo = "turret_mini"

SWEP.TurretType = 7
SWEP.Tier = 6
SWEP.MaxStock = 1

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.75)