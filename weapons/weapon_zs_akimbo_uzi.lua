AddCSLuaFile()

SWEP.Base = "weapon_zs_base_akimbo"

if CLIENT then
    SWEP.WElements = {
        ["fixleft"] = { type = "Model", model = "models/weapons/w_smg_mac10.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.001, 0.001, 0.001), color = Color(165, 165, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["UZIWM2"] = { type = "Model", model = "models/weapons/w_smg_mac10.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "fixleft", pos = Vector(3.635, 1.5, -3.5), angle = Angle(0, 0, 0), size = Vector(0.99, 1.014, 0.99), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["UZIWM1"] = { type = "Model", model = "models/weapons/w_smg_mac10.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.5, 3.5), angle = Angle(0, 0, 180), size = Vector(0.99, 1.014, 0.99), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
    }
end

SWEP.PrintName = "'Akimbo Sprayer' Uzi 9mm" --(translate.Get("wep_deagle"))
SWEP.Description = (translate.Get("desc_uziakimbo"))
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.ViewModel_L = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = true

SWEP.SoundFireVolume = 1
SWEP.SoundPitchMin = 100
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapons/mac10/mac10-1.wav"
SWEP.Primary.Damage = 17.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.075

SWEP.SoundFireVolume_S = 1
SWEP.SoundPitchMin_S = 100
SWEP.SoundPitchMax_S = 110

SWEP.Secondary.Sound = ")weapons/mac10/mac10-1.wav"
SWEP.Secondary.Damage = 16.5
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Delay = 0.075

SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 350
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.Secondary.ClipSize = 35
SWEP.Secondary.DefaultClip = 350
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "smg1"

SWEP.RequiredClip = 1
SWEP.Auto = true
SWEP.CantSwitchFireModes = true

SWEP.ConeMax = 5.5 * 1.3
SWEP.ConeMin = 2.5 * 1.3

SWEP.ConeMax_S = 5.5 * 1.3
SWEP.ConeMin_S = 2.5 * 1.3

SWEP.FireAnimSpeed = 1.5

SWEP.Tier = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.58, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.27, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 3, 1)