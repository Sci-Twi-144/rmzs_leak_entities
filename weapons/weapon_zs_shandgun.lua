AddCSLuaFile()

SWEP.PrintName = "Special Handgun"

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DPos = Vector(-1.25, 0, 1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DBone = "v_weapon.USP_Slide"
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(-1, -2, 0)
	SWEP.VMAng = Angle(1, 0, 0)

	SWEP.ViewModelBoneMods = {
		["v_weapon.USP_Slide"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(3, -0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -12, 0) )
            self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos, Vector(-0, 0, 15) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
            self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos, lBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp_silencer.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/usp/usp1.wav")
SWEP.Primary.Damage = 42
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.2

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.IronSightsPos = Vector(-4.92, -1, 2.4)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.ConeMax = 1.5
SWEP.ConeMin = 0.75

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.0175, 1)

SWEP.IdleActivity = ACT_VM_IDLE_SILENCED

SWEP.NoDismantle = true
SWEP.Undroppable = true
SWEP.AllowQualityWeapons = false

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = self:GetIronsights() and ACT_VM_IDLE_SILENCED or ACT_VM_PRIMARYATTACK_SILENCED
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_RELOAD_SILENCED)
end

function SWEP:GetAuraRange()
	return 0
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
	self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
	return true
end

