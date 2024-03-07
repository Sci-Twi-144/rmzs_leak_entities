AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_drone")

SWEP.Base = "weapon_zs_drone"

SWEP.PrintName = (translate.Get("wep_drone_pulse"))
SWEP.Description = (translate.Get("desc_drone_pulse"))

SWEP.Primary.Ammo = "pulse_cutter"

SWEP.DeployClass = "prop_drone_pulse"
SWEP.DeployAmmoType = "pulse"
SWEP.ResupplyAmmoType = "pulse"
