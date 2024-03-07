AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")
SWEP.PrintName = (translate.Get("wep_shroud"))
SWEP.Description = (translate.Get("desc_shroud"))

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 74
	SWEP.ShowWorldModel = false 

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(1.05, -2.5, 0.75)
	SWEP.HUD3DAng = Angle(180, 0, -115)
	SWEP.HUD3DScale = 0.015

	SWEP.VElements = {
		["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_suppressor_mk23.mdl", bone = "Weapon", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/tfa_ins2/mk23/mk23_body", skin = 0, bonemerge = true, bodygroup = {}, active = false },
		--["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "Weapon", rel = "", pos = Vector(0.01, 5.8, -0.69), angle = Angle(0, -90, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, bodygroup = {}, active = false },
	}
	SWEP.WElements = {
		["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_suppressor_mk23.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "weapon", pos = Vector(6.5999999046326, 0, 2.25), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/tfa_ins2/mk23/mk23_body", skin = 0, bodygroup = {} },
		["weapon"] = { type = "Model", model = "models/weapons/tfa_ins2/w_mk23.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.1000000238419, -1.2999999523163), angle = Angle(0, -7, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.ViewModelBoneMods = {
		["Slide"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VMPos = Vector(1.95, 3, -0.95)
	SWEP.VMAng = Angle(0, 0, 0)
	local lBarrelOrigin = Vector(0, 0, 0)
    function SWEP:Think()
        if (self:Clip1() == 0) and not (self:GetReloadFinish() > 0) then
            self.ViewModelBoneMods[ "Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "Slide" ].pos, Vector(0, 1.85, 0) )
        else
            self.ViewModelBoneMods[ "Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "Slide" ].pos, lBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end


	SWEP.LowAmmoSoundThreshold = 0.33
	SWEP.LowAmmoSoundHandgun = ")weapons/tfa/lowammo_indicator_handgun.wav"
	SWEP.LastShot = ")weapons/tfa/lowammo_dry_handgun.wav"
	function SWEP:EmitFireSound()
		BaseClass.EmitFireSound(self)
		local clip1, maxclip1 = self:Clip1(), self:GetMaxClip1()
		local mult = clip1 / maxclip1
		self:EmitSound(self.LowAmmoSoundHandgun, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
		if self:Clip1() <= 1 then
			self:EmitSound(self.LastShot, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
		end
	end

--[[
	SWEP.MoveHandUp = 0
	SWEP.MoveHandDown = 0
	SWEP.ReloadTimerAnim = 0
	SWEP.ReadyHandLeftDown = 0

	local function RestartValueDeploy(self)
		self.MoveHandUp = 0
		self.MoveHandDown = 0
		self.ReadyHandLeftDown = CurTime() + self:SequenceDuration() * 0.65
		self.ReloadTimerAnim = 0
	end

	function SWEP:Deploy()
		self.BaseClass.Deploy(self)

		RestartValueDeploy(self)

		return true
	end

	local function HandDropDown(self)
		local owner = self:GetOwner()
		if self.ReadyHandLeftDown <= CurTime() then
			if self.ReloadTimerAnim <= CurTime() and not owner:Crouching() and owner:IsOnGround() and not owner:IsHolding() then
				self.MoveHandDown = math.max(-10, self.MoveHandDown - 0.05)
				self.MoveHandUp = math.min(5, self.MoveHandUp + 0.05)
			else
				self.MoveHandDown = math.min(0, self.MoveHandDown + 0.09)
				self.MoveHandUp = math.max(0, self.MoveHandUp - 0.09)
			end
		end

		self.ViewModelBoneMods["ValveBiped.Bip01_L_Clavicle"].pos = Vector(self.MoveHandDown, 0, self.MoveHandUp)
	end

	function SWEP:PostDrawViewModel(vm)
		self.BaseClass.PostDrawViewModel(self, vm)

		HandDropDown(self)
	end

	function SWEP:DrawHUD()
		self.BaseClass.DrawHUD(self)

		HandDropDown(self)
	end
	]]

end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/tfa_ins2/c_mk23.mdl" --Viewmodel path
SWEP.WorldModel = "models/weapons/tfa_ins2/w_mk23.mdl" -- Weapon world model path

SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/tfa_ins2/mk23/m45_suppressed_fp.wav"
SWEP.Primary.Damage = 48
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.2
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 12
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.FireAnimSpeed = 1
SWEP.HeadshotMulti = 2.2

SWEP.Primary.Ammo = "pistol"
SWEP.ConeMax = 1.8
SWEP.ConeMin = 0.9

SWEP.Tier = 3

SWEP.ResistanceBypass = 0.8

SWEP.IronSightsPos = Vector(-4.345, -2, 1.365)
SWEP.IronSightsAng = Vector(-0.24, 0, 0)
SWEP.NewNames = {"Cloaked", "Covert", "Silent"}

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RESISTANCE_BYPASS, -0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.1, 1)

SWEP.IronAnim = ACT_VM_PRIMARYATTACK_1
function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
	self.ReloadTimerAnim = CurTime() + self:SequenceDuration() / (1.25 * self:GetReloadSpeedMultiplier())
end

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_1 or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:GetAuraRange()
	return 512
end

sound.Add({
	name = 			"TFA_INS2.MK23.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mk23/boltback.wav"
})

sound.Add({
	name = 			"TFA_INS2.MK23.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mk23/boltrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2.MK23.Boltslap",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mk23/boltslap.wav"
})

sound.Add({
	name = 			"TFA_INS2.MK23.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mk23/empty.wav"
})

sound.Add({
	name = 			"TFA_INS2.MK23.MagHit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mk23/maghit.wav"
})

sound.Add({
	name = 			"TFA_INS2.MK23.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mk23/magin.wav"
})

sound.Add({
	name = 			"TFA_INS2.MK23.Magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mk23/magout.wav"
})

sound.Add({
	name = 			"TFA_INS2.MK23.Magrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/mk23/magrelease.wav"
})