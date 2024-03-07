AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_peashooter"))
SWEP.Description = (translate.Get("desc_peashooter"))

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.p228_Slide"
	SWEP.HUD3DPos = Vector(-0.88, 0.35, 1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "SEMI"
		else
			return "AUTO"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "SEMI"
		else
			return "AUTO"
		end
	end	

	function SWEP:GetDisplayAmmo(clip, spare, maxclip)
		local minus = self:GetAltUsage() and 0 or 1
		return math.max(0, (clip * 2) - minus), spare * 2, maxclip * 2
	end

	SWEP.ViewModelBoneMods = {
		["v_weapon.p228_Slide"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)
	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(3, -0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -12, 0) )
            self.ViewModelBoneMods[ "v_weapon.p228_Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.p228_Slide" ].pos, Vector(0, 0, 10) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
            self.ViewModelBoneMods[ "v_weapon.p228_Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.p228_Slide" ].pos, lBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 90
SWEP.SoundPitchMax = 95

SWEP.Primary.Sound = ")weapons/p228/p228-1.wav"
SWEP.Primary.Damage = 16.25
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.25

SWEP.Primary.ClipSize = 9
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.ClipMultiplier = 12/18 * 2 -- Battleaxe/Owens have 12 clip size, but this has half ammo usage
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ResistanceBypass = 0.65

SWEP.ConeMax = 4
SWEP.ConeMin = 0.75

SWEP.IronSightsPos = Vector(-5.95, -1, 2.55)

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true
SWEP.StandartIronsightsAnim = false

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Primary.ClipSize = 9
		self.Primary.Damage = 16.25
		self.Primary.Delay = 0.25
		self.Primary.Automatic = false
		self.ConeMin = 0.75
	elseif self:GetFireMode() == 1 then
		self.Primary.ClipSize = math.floor(self.Primary.ClipSize * 1.25)
		self.Primary.Damage = self.Primary.Damage * 0.9
		self.Primary.Delay = 0.15
		self.Primary.Automatic = true
		self.ConeMin = 2.25
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end

function SWEP:SetAltUsage(usage)
	self:SetDTBool(8, usage)
end

function SWEP:GetAltUsage()
	return self:GetDTBool(8)
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

	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end