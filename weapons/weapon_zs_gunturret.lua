AddCSLuaFile()

SWEP.Base = "weapon_zs_gunturretbase"

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/Combine_turrets/Floor_turret.mdl"

SWEP.PrintName = (translate.Get("wep_gunturret"))
SWEP.Description = (translate.Get("desc_gunturret"))

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "thumper"
SWEP.Primary.Damage = 8.6
SWEP.HeatBuildShort = 0.01

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.MaxStock = 5

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.FullWalkSpeed = SPEED_SLOWEST

SWEP.TurretType = 1
SWEP.SearchDistance = 768
SWEP.GhostStatus = "ghost_gunturretm"
SWEP.DeployClass = "prop_gunturret"
SWEP.Channel = "turret"

SWEP.TurretAmmoType = "smg1"
SWEP.TurretAmmoStartAmount = 250
SWEP.TurretSpread = 2

SWEP.NoDeploySpeedChange = true
SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.4)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_gunturret_pulse")), (translate.Get("desc_gunturret_pulse")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.8
	
	wept.GhostStatus = "ghost_gunturret_pulse"
	wept.DeployClass = "prop_gunturret"
	wept.Channel = "turret"

	wept.TurretAmmoType = "pulse"
	wept.TurretAmmoStartAmount = 125
	wept.TurretSpread = wept.TurretSpread * 1.5 --3
	wept.HeatBuildShort = 0.02
	
	wept.TurretType = 5
	wept.SearchDistance = 392
	
	wept.Primary.NumShots = 1

	wept.InnateTrinket = "trinket_pulse_rounds"
    wept.LegDamageMul = 1
	wept.LegDamage = 1
end)

GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_gunturret_buckshot")), (translate.Get("desc_gunturret_buckshot")), function(wept)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_TURRET_SPREAD, -0.9)
	wept.Primary.Damage = wept.Primary.Damage * 0.791
	wept.Primary.NumShots = 7

	wept.GhostStatus = "ghost_gunturret_buckshot2"
	wept.DeployClass = "prop_gunturret"
	wept.Channel = "turret"

	wept.TurretAmmoType = "buckshot"
	wept.TurretAmmoStartAmount = 25
	wept.TurretSpread = wept.TurretSpread * 2.5--5
	wept.HeatBuildShort = 0.1
	
	wept.TurretType = 2
	wept.SearchDistance = 225
end)
