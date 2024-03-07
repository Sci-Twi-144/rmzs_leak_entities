SWEP.PrintName = (translate.Get("wep_helldash"))
SWEP.Description = (translate.Get("desc_helldash"))

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_Barrel.Fire")
SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.Delay = 0.3
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Damage = 124
SWEP.Primary.NumShots = 1

SWEP.ConeMax = 5
SWEP.ConeMin = 3.5
SWEP.ReloadSpeed = 0.8

SWEP.Primary.ProjExplosionTaper = 0.6
SWEP.Primary.ProjExplosionRadius = 85

SWEP.Colors = {Color(255, 110, 110), Color(255, 50, 50), Color(255, 0, 0)}

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 6
--SWEP.MaxStock = 3
SWEP.IsAoe = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.03, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
--GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_eminence")), (translate.Get("desc_eminence")), "weapon_zs_eminence") -- just fuck it, idc to fix

sound.Add({
	name = 			"Weapon_Barrel.Fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			{")physics/metal/metal_barrel_impact_hard1.wav", ")physics/metal/metal_barrel_impact_hard2.wav", ")physics/metal/metal_barrel_impact_hard3.wav"}
})
