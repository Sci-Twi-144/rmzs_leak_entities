AddCSLuaFile()

SWEP.Base = "weapon_zs_base_akimbo"

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "v_weapon.Deagle_Slide"
	SWEP.HUD3DPos = Vector(-1, 0, 0)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

    SWEP.HUD3DBone2 = "v_weapon.Deagle_Slide"
    SWEP.HUD3DPos2 = Vector(-1.2, 0, 0)
    SWEP.HUD3DAng2 = Angle(0, 180, 0)
    SWEP.HUD3DScale = 0.015

	SWEP.VElementsR = {}
	SWEP.VElementsL = {}
	SWEP.WElements = {
		["wep_right"] = { type = "Model", model = "models/weapons/w_pist_deagle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.5, 1, 2.5), angle = Angle(0, -13, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_left"] = { type = "Model", model = "models/weapons/w_pist_deagle.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.5, 1, -2.5), angle = Angle(0, -10, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.IronSightsPos = Vector(-2, -1, 1)

	--SWEP.VMPos = Vector(-1, -7, -0.25)
	SWEP.VMAng = Vector(1, 0, 0)
end

SWEP.PrintName = (translate.Get("wep_deagle_aki"))
SWEP.Description = (translate.Get("desc_deagle_aki"))
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.ViewModel_L = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapons/DEagle/deagle-1.wav"
SWEP.Primary.Damage = 57
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.32
SWEP.Primary.KnockbackScale = 2

SWEP.SoundPitchMin_S = 95
SWEP.SoundPitchMax_S = 110

SWEP.Secondary.Sound = ")weapons/DEagle/deagle-1.wav"
SWEP.Secondary.Damage = 57
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Delay = 0.32

SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 70
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Secondary.ClipSize = 7
SWEP.Secondary.DefaultClip = 70
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "pistol"

SWEP.RequiredClip = 1
SWEP.HeadshotMulti = 2.2
SWEP.FireAnimSpeed = 1.3
SWEP.Tier = 3

SWEP.ConeMax = 3.16 * 1.3
SWEP.ConeMin = 1.16 * 1.3

SWEP.ConeMax_S = 3.16 * 1.3
SWEP.ConeMin_S = 1.16 * 1.3

SWEP.ShouldMuzzleL = true
SWEP.ShouldMuzzleR = true

SWEP.FireAnimIndexMin = 1
SWEP.FireAnimIndexMax = 2
SWEP.ReloadAnimIndex = 4
SWEP.DeployAnimIndex = 5

SWEP.FireAnimIndexMin_S = 1
SWEP.FireAnimIndexMax_S = 2
SWEP.ReloadAnimIndex_S = 4
SWEP.DeployAnimIndex_S = 5

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)