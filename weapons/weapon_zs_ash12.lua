AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_ash12"))
SWEP.Description = (translate.Get("desc_ash12"))

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55

    SWEP.HUD3DBone = "ash12"
    SWEP.HUD3DPos = Vector(4.5, -14.3, 1.5)
    SWEP.HUD3DAng = Angle(270, 0, 90)
    SWEP.HUD3DScale = 0.015

    SWEP.VMPos = Vector(1.5, 0, -1.5)
    SWEP.VMAng = Angle(0, 0, 0)
    
    SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/w_rif_ash12.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10, 0.75, -4.6750001907349), angle = Angle(-10, -1.1000000238419, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
    
    SWEP.ViewModelBoneMods = {
        ["A_Optic"] = { scale = Vector(1, 1, 1), pos = Vector(0, -1, 1.05), angle = Angle(90, 0, 0) },
        ["A_Suppressor"] = { scale = Vector(1.1, 0.75, 1.1), pos = Vector(0, -0.7, 0), angle = Angle(0, 0, 0) },
        ["A_Muzzle_Supp"] = { scale = Vector(1, 1, 1), pos = Vector(0, 3, 0), angle = Angle(0, 0, 0) },
        ["A_LaserFlashlight"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.05), angle = Angle(0, 0, 180) },
        ["tag_reflex"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 1.05), angle = Angle(0, 0, 90) },
    }

	local uBarrelOrigin = SWEP.VMPos
	local BarAngle = SWEP.VMAng
	function SWEP:Think()
		if self.IsShooting >= CurTime() then
			self.VMPos = LerpVector( FrameTime() * 1, self.VMPos, Vector(1.5, -5, -1.5) )
		else
			self.VMPos = LerpVector( FrameTime() * 2, self.VMPos,  uBarrelOrigin )
		end

		if not self:GetIronsights() then
			if self.Shoot then
				self.VMPos = LerpVector( RealFrameTime() * 4, self.VMPos, Vector(0, -8, 0) )
				self.VMAng = LerpAngle( RealFrameTime() * 3, self.VMAng, Angle(12, math.random(-6, 6), math.random(-18, 18)) )
				self.Shoot = false
			else
				self.VMPos = LerpVector( RealFrameTime() * 4, self.VMPos,  uBarrelOrigin )
				self.VMAng = LerpAngle( RealFrameTime() * 3, self.VMAng, BarAngle )
			end
		end
		self.BaseClass.Think(self)
	end	


	SWEP.LowAmmoSoundThreshold = 0.33
	SWEP.LowAmmoSound = ")weapons/tfa/lowammo_indicator_automatic.wav"
	SWEP.LastShot = ")weapons/tfa/lowammo_dry_automatic.wav"
	function SWEP:EmitFireSound()
		BaseClass.EmitFireSound(self)
		local clip1, maxclip1 = self:Clip1(), self:GetMaxClip1()
		local mult = clip1 / maxclip1
		self:EmitSound(self.LowAmmoSound, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
		if self:Clip1() <= 1 then
			self:EmitSound(self.LastShot, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
		end
	end

	function SWEP:GetDisplayAmmo(clip, spare, maxclip)
		local minus = self:GetAltUsage() and 0 or 1
		return math.max(0, (clip * 2) - minus), spare * 2, maxclip * 2
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_rif_ash12.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ash12.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.Primary.Sound = Sound(")weapons/ash12/shoot.wav")
SWEP.Primary.Damage = 68.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.18
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 10
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Ammo = "357"
SWEP.ConeMax = 3.25
SWEP.ConeMin = 1.75

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.ResistanceBypass = 0.5

SWEP.Pierces = 2

SWEP.ProjExplosionTaper = 0.4
SWEP.DamageTaper = SWEP.ProjExplosionTaper

SWEP.Shoot = false

SWEP.IronSightsPos = Vector(-4.82, -3.404, 0.473)
SWEP.IronSightsAng = Vector(1.011, 0, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TAPER, 0.05, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_ak103")), (translate.Get("desc_ak103")), "weapon_zs_ak103")

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = ACT_VM_IDLE--self:GetIronsights() and ACT_VM_IDLE or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitFireSound()

	local altuse = self:GetAltUsage()
	if not altuse then
		self:TakeAmmo()
	end
	self:SetAltUsage(not altuse)

	if CLIENT then
		self.Shoot = true
	end

	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SetAltUsage(usage)
	self:SetDTBool(8, usage)
end

function SWEP:GetAltUsage()
	return self:GetDTBool(8)
end