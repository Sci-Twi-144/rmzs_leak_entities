AddCSLuaFile()

SWEP.Base = "weapon_zs_gunturretbase"

SWEP.PrintName = (translate.Get("wep_gunturret_disintigrator"))
SWEP.Description = (translate.Get("desc_gunturret_disintigrator"))

SWEP.Primary.Damage = 100
SWEP.Primary.Delay = 1.3

SWEP.GhostStatus = "ghost_gunturret_des"
SWEP.DeployClass = "prop_gunturret"
SWEP.TurretAmmoType = "pulse"
SWEP.TurretAmmoStartAmount = 90
SWEP.TurretSpread = 1.5

SWEP.Primary.Ammo = "turret_disintigrator"
SWEP.SearchDistance = 1024
SWEP.HeatBuildShort = 0.1
SWEP.Pierces = 2
SWEP.ProjExplosionTaper = 0.5

SWEP.TurretType = 6
SWEP.Tier = 6
SWEP.MaxStock = 1

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.45)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1, 1)