AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_ruger"))
SWEP.Description = (translate.Get("desc_ruger"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "mini14_parent"
	SWEP.HUD3DPos = Vector(1.3, -2.5, 2)
	SWEP.HUD3DAng = Angle(0, 180, 180)
	SWEP.HUD3DScale = 0.013

	SWEP.ViewModelBoneMods = {
		["mini14_slide"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)
	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(0, 0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -18, 0) )
            self.ViewModelBoneMods[ "mini14_slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "mini14_slide" ].pos, Vector(0, 0, -15) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
            self.ViewModelBoneMods[ "mini14_slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "mini14_slide" ].pos, lBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_ruger_a1.mdl"
SWEP.WorldModel = "models/weapons/w_ruger_a1.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/zs_ruger/fire.wav"
SWEP.Primary.Damage = 24
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12

SWEP.Recoil = 0

SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 3
SWEP.ConeMin = 0.85

SWEP.WalkSpeed = SPEED_SLOW

SWEP.ResistanceBypass = 0.65

SWEP.HeadshotMulti = 2.25

SWEP.Tier = 3

SWEP.IronSightsPos = Vector(-4.305, -3, 2.55)

SWEP.StandartIronsightsAnim = false

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5)

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
	self.IdleActivity = ACT_VM_IDLE
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
end

--[[
function SWEP:SendReloadAnimation()
	self:SendWeaponAnim((self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD)
end
sound.Add({
	name = 			"Fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/zs_ruger/fire.wav"
})
]]
sound.Add({
	name = 			"Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_ruger/magout.wav"	
})

sound.Add({
	name = 			"Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_ruger/magin.wav"	
})

sound.Add({
	name = 			"BoltBack",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_ruger/back.wav"	
})

sound.Add({
	name = 			"BoltForward",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_ruger/forward.wav"	
})