AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_fnp"))
SWEP.Description = (translate.Get("desc_fnp"))

SWEP.Spawnable = true

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "weapon"
	SWEP.HUD3DPos = Vector(0.65, -2.5, 0.4)
	SWEP.HUD3DAng = Angle(180, 0, -125)
	SWEP.HUD3DScale = 0.01

	SWEP.VMPos = Vector(1.5, 3, -0.5)

	SWEP.ViewModelBoneMods = {
		["A_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -90) },
		["A_Suppressor"] = { scale = Vector(0.97, 0.97, 0.96), pos = Vector(0, -0.04, 0.05), angle = Angle(0, 0, 0) },
		["A_Underbarrel"] = { scale = Vector(1.05, 1.05, 1.05), pos = Vector(0, -1.4, -0.28), angle = Angle(0, 0, 0) },
		["R UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0.08), angle = Angle(0, 0, 0) },	
		["Trigger"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.065, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	--	["R Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	--	["R Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	--	["R Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	--	["R Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	}

	local wmscale = Vector(1 / 1.3, 1 / 1.3, 1 / 1.3)

	SWEP.WorldModelBoneMods = {
		["Muzzle"] = { scale = wmscale, pos = Vector(-0.25, 0, 0), angle = Angle(0, 0, 0) },
		["ATTACH_Laser"] = { scale = wmscale, pos = Vector(-1, 0, 0), angle = Angle(0, 0, 0) },
	}

	SWEP.VElements = {
		["mag"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_magazine_fnp45_15.mdl", bone = "Magazine", rel = "", pos = Vector(90, 0, 90), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = true, bonemerge = true },
		--["mag_ext"] = { type = "Model", model = "models/weapons/upgrades/a_magazine_fnp45_18.mdl", bone = "Magazine", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
		--["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_suppressor_pistol.mdl", bone = "A_Suppressor", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 90, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
		
		--["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_laser_cz75a.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(-0.7, 0, 0.3), angle = Angle(0, 0, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
		--["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Beam", rel = "laser", pos = Vector(0, 0, -0.5), angle = Angle(0, 0, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
		--["laser_x400"] = { type = "Model", model = "models/weapons/upgrades/a_laser_p320.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = true, active = false, bodygroup = {} },
		--["laser_beam_x400"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "LaserPistol", rel = "laser_x400", pos = Vector(0, 0, -0.45), angle = Angle(0, 90, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
		
		--["sight_rmr"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_rmr.mdl", bone = "Slide", rel = "", pos = Vector(0, -1.35, 0.582), angle = Angle(0, 180, 0), size = Vector(0.7, 0.8, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
		--["sight_rmr_lens"] = (TFA.EFTC and TFA.EFTC.GetHoloSightReticle) and TFA.EFTC.GetHoloSightReticle("sight_rmr") or nil,
	
		--["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_flashlight_rail.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(-2, 0, 0.6), angle = Angle(0, 0, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
		--["flashlight_lastac"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_lastac.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(-2.75, 0, 0.2), angle = Angle(0, -90, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
		--["suppressor_osprey"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_osprey.mdl", bone = "A_Suppressor", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.85, 0.95, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
		--["suppressor_aac"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_aac.mdl", bone = "A_Suppressor", rel = "", pos = Vector(0, 0, 0.01), angle = Angle(0, 0, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} }
	}

	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/w_ins2_pist_fnp45.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.5, -1.2999999523163), angle = Angle(0, -15, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["mag"] = { type = "Model", model = "models/weapons/upgrades/a_magazine_fnp45_15.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "weapon", pos = Vector(-13.1, -2.2, 4), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		--["mag"] = { type = "Model", model = "models/weapons/upgrades/a_magazine_fnp45_15.mdl", bone = "W_PIS_MAGAZINE", rel = "", pos = Vector(2.2, -13.1, 4), angle = Angle(0, -90, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = true, bonemerge = false },
		--["mag_ext"] = { type = "Model", model = "models/weapons/upgrades/a_magazine_fnp45_18.mdl", bone = "W_PIS_MAGAZINE", rel = "", pos = Vector(2.2, -13.1, 4), angle = Angle(0, -90, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = false },
		--["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_sil_pistol.mdl", bone = "ATTACH_Muzzle", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = true, active = false, bodygroup = {} },
		--["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_sec.mdl", bone = "ATTACH_Laser", rel = "", pos = Vector(1.2, 10.7, 0), angle = Angle(180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
		--["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_sec.mdl", bone = "ATTACH_Laser", rel = "", pos = Vector(1.2, 10.7, 0), angle = Angle(180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"
SWEP.LoweredHoldType = "normal"

SWEP.ViewModel = "models/weapons/c_ins2_pist_fnp45.mdl"
SWEP.WorldModel = "models/weapons/w_ins2_pist_fnp45.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/fnp/fnp_fire.wav" --fnp_suppressed
SWEP.Primary.Damage = 47.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.145
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 15
GAMEMODE:SetupDefaultClip(SWEP.Primary)
SWEP.Primary.Recoil = 0.75

--SWEP.FireAnimSpeed = 0.75

SWEP.Primary.Ammo = "pistol"
SWEP.BulletType = SWEP.Primary.Ammo
SWEP.ConeMax = 2.4
SWEP.ConeMin = 1.1

SWEP.Tier = 4

SWEP.IronSightsPos = Vector(-3.3565, -3, 0.785)
SWEP.IronSightsAng = Vector(0.1, -0.01, 0)

SWEP.IronSightActivity = ACT_VM_PRIMARYATTACK_1
SWEP.StandartIronsightsAnim = true

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
end

sound.Add(
{
	name = "TFA_INS2.FNP45.Safety",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_safety.wav"
})

sound.Add(
{
	name = "TFA_INS2.FNP45.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_boltback.wav"
})

sound.Add(
{
	name = "TFA_INS2.FNP45.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_boltrelease.wav"
})

sound.Add(
{
	name = "TFA_INS2.FNP45.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_empty.wav"
})

sound.Add(
{
	name = "TFA_INS2.FNP45.Magrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_magrelease.wav"
})

sound.Add(
{
	name = "TFA_INS2.FNP45.Magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_magout.wav"
})

sound.Add(
{
	name = "TFA_INS2.FNP45.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_magin.wav"
})

sound.Add(
{
	name = "TFA_INS2.FNP45.MagHit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_maghit.wav"
})

sound.Add(
{
	name = "TFA_INS2.FNP45.Boltslap",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = "weapons/fnp/fnp_boltback.wav"
})