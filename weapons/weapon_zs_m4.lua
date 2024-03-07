AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_m4"))
SWEP.Description = (translate.Get("desc_m4"))
SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 80

	SWEP.HUD3DBone = "m16_parent"
	SWEP.HUD3DPos = Vector(1.5, -0.5, 4)
	SWEP.HUD3DAng = Angle(180, 0, -25)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(2.25, -1, -1.25)
	SWEP.VMAng = Angle(0, 0, 0)

	SWEP.VElements = {
		["suppressor"] = { type = "Model", model = "models/weapons/rmzs/attachments/c_silencer_m4a1_new.mdl", bone = "m16_parent", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = true, bodygroup = {}, active = false }
	}
	SWEP.WElements = {
		["suppressor"] = { type = "Model", model = "models/weapons/rmzs/attachments/w_silencer_m4a1_new.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.10000038147, 0.75, -12.5), angle = Angle(-10, 0.69999998807907, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	function SWEP:Think()
		BaseClass.Think(self)
		if self.IsShooting >= CurTime() then
			self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(math.random(2.0, 2.5), -6, math.random(-1.0, -1.4)) )
		else
			self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
		end
	end	
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/rmzs/c_m4a1_new.mdl"
SWEP.WorldModel = "models/weapons/rmzs/w_m4a1_new.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")weapons/m4a1/m4a1-1.wav"--")weapons/m4a1/m4a1_unsil-1.wav"
SWEP.Primary.Sound = Sound(")weapons/rmzs/m4a1/fire_sup.ogg")
SWEP.Primary.Damage = 25.05
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1

SWEP.ResistanceBypass = 0.65

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 5
SWEP.ConeMin = 1.5

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 4

SWEP.IronSightsPos = Vector(-5.1, 1, 1.39)
SWEP.IronSightsAng = Vector(0.75, 0, 0)

SWEP.AuraRange = 2048

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
	local dfanim = self:GetIronsights() and ACT_VM_IDLE or ACT_VM_PRIMARYATTACK
	self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.625)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.187)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 2)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5, 1)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_aspirant")
