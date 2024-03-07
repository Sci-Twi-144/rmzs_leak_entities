DEFINE_BASECLASS("weapon_zs_base")

AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_steyr"))
SWEP.Description = (translate.Get("desc_steyr"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.TMP_Parent"
	SWEP.HUD3DPos = Vector(-1, -3.5, -1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

    SWEP.VElements = {
        ["gun1"] = { type = "Model", model = "models/phxtended/bar1x45a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(4.387, -0.473, 1.764), angle = Angle(0, -90, 0), size = Vector(0.158, 0.119, 0.175), color = Color(230, 240, 230, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
        ["gun2"] = { type = "Model", model = "models/props_phx/misc/iron_beam1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(5.098, 0, 1.375), angle = Angle(0, 0, 0), size = Vector(0.224, 0.111, 0.086), color = Color(230, 240, 230, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
        ["base"] = { type = "Model", model = "models/props_c17/gravestone001a.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0.014, -1.315, 14.435), angle = Angle(-90, 90, 0), size = Vector(0.143, 0.061, 0.075), color = Color(230, 240, 230, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
        ["gun4"] = { type = "Model", model = "models/mechanics/robotics/claw.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(6.373, 0, -0.662), angle = Angle(-180, 0, -90), size = Vector(0.314, 0.103, 0.122), color = Color(230, 240, 230, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
        ["gun3"] = { type = "Model", model = "models/hunter/triangles/3x3x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(1.842, 0, -0.357), angle = Angle(-180, -90, 0), size = Vector(0.008, 0.023, 0.026), color = Color(230, 240, 230, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} }
    }
    
    SWEP.WElements = {
        ["gun1"] = { type = "Model", model = "models/phxtended/bar1x45a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(4.387, -0.473, 1.764), angle = Angle(0, -90, 0), size = Vector(0.158, 0.119, 0.175), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
        ["gun2"] = { type = "Model", model = "models/props_phx/misc/iron_beam1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(5.098, 0, 1.375), angle = Angle(0, 0, 0), size = Vector(0.224, 0.111, 0.086), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
        ["base"] = { type = "Model", model = "models/props_c17/gravestone001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-11.254, 0.688, 1.797), angle = Angle(-13.346, 0, -180), size = Vector(0.143, 0.061, 0.075), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
        ["gun4"] = { type = "Model", model = "models/mechanics/robotics/claw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(6.373, 0, -0.662), angle = Angle(-180, 0, -90), size = Vector(0.414, 0.103, 0.122), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
        ["gun3"] = { type = "Model", model = "models/hunter/triangles/3x3x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(1.842, 0, -0.357), angle = Angle(-180, -90, 0), size = Vector(0.008, 0.023, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} }
    }
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_tmp.mdl"
SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapons/tmp/tmp-1.wav"
SWEP.Primary.Damage = 22.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.4
SWEP.Primary.BurstShots = 3

SWEP.Primary.ClipSize = 21
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 0.723 --72
SWEP.FireAnimSpeed = 3

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 1.9
SWEP.ConeMin = 0.81

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.Tier = 3

SWEP.ResistanceBypass = 0.85

SWEP.IronSightsPos = Vector(-7, 3, 2.5)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.3656)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.1575)

function SWEP:GetAuraRange()
	return 384
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end

    self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
    self:EmitFireSound()

    self:SetNextShot(CurTime())
    self:SetShotsLeft(self.Primary.BurstShots)

    self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:Think()
    BaseClass.Think(self)

    self:ProcessBurstFire()
end