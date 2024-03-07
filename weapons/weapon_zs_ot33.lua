AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_ot33"))
SWEP.Description = (translate.Get("desc_ot33"))


SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 56
	SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(1, -1, 0.5)
	SWEP.HUD3DAng = Angle(0, 180, 75)
	SWEP.HUD3DScale = 0.0125

	SWEP.VMPos = Vector(2, 9, -1)

	SWEP.VElements = {}
	SWEP.WElements = {
		["element_name"] = { type = "Model", model = "models/weapons/w_ins2_pist_ots33.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.5, 1.5, -2.3), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-10, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(-0.0, -0.05, 0.2), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0.25, 0, 0), angle = Angle(0, 0, 0) }
		
	}
	
	killicon.Add("weapon_ot33", "vgui/hud/weapon_ot33", Color(255, 80, 0, 191))
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"
SWEP.LoweredHoldType = "normal"

SWEP.ViewModel = "models/weapons/c_ins2_pist_ots33.mdl"
SWEP.WorldModel	= "models/weapons/w_ins2_pist_ots33.mdl"
SWEP.UseHands = true

SWEP.Primary.Recoil = 2.76

SWEP.Primary.Sound = Sound(")weapons/ots33/fire1.wav")
SWEP.Primary.Damage = 46.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 18

SWEP.FireAnimSpeed = 0.75

SWEP.Primary.Recoil = 2.25

SWEP.Tier = 5

SWEP.Primary.Ammo = "pistol"
SWEP.BulletType = SWEP.Primary.Ammo
SWEP.ConeMax = 3.3
SWEP.ConeMin = 2.0

SWEP.IronSightsPos = Vector(-3.8505, -4.4, 0.41)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.IronSightActivity  = ACT_VM_PRIMARYATTACK_1
SWEP.StandartIronsightsAnim = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 3, 1)

sound.Add(
{
	name = "TFA_INS2.OTS33.Safety",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_safety.wav"
})

sound.Add(
{
	name = "TFA_INS2.OTS33.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_boltback.wav"
})

sound.Add(
{
	name = "TFA_INS2.OTS33.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_boltrelease.wav"
})

sound.Add(
{
	name = "TFA_INS2.OTS33.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_empty.wav"
})

sound.Add(
{
	name = "TFA_INS2.OTS33.Magrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_magrelease.wav"
})

sound.Add(
{
	name = "TFA_INS2.OTS33.Magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_magout.wav"
})

sound.Add(
{
	name = "TFA_INS2.OTS33.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_magin.wav"
})

sound.Add(
{
	name = "TFA_INS2.OTS33.MagHit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_maghit.wav"
})

sound.Add(
{
	name = "TFA_INS2.OTS33.Boltslap",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_boltback.wav"
})
