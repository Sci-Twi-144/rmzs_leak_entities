AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_owens"))
SWEP.Description = (translate.Get("desc_owens"))

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(0.9, -2, 0.4)
	SWEP.HUD3DAng = Angle(0, 180, 75)
	SWEP.HUD3DScale = 0.0125

	SWEP.VMPos = Vector(1.5, 4, -0.5)
	SWEP.VMAng = Angle(0, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_owens.mdl"
SWEP.WorldModel = "models/weapons/w_owens.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.SoundFireVolume = 0.3
SWEP.SoundPitchMin = 90
SWEP.SoundPitchMax = 120
SWEP.Primary.Sound = ")weapons/pistols/owens_fire.wav"
SWEP.Primary.Damage = 14.75
SWEP.Primary.NumShots = 2
SWEP.Primary.Delay = 0.2

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.ClipMultiplier = 12/12
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 1

SWEP.ConeMax = 4
SWEP.ConeMin = 2.5

SWEP.IronSightsPos = Vector(-4.2, -1.25, 1.5)
SWEP.IronSightsAng = Vector(0, 0, 5)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.23, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.11, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.0175, 1)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_peashooter")
GAMEMODE:AddNewRemantleBranch(SWEP, 2, nil, nil, "weapon_zs_battleaxe")

function SWEP:SendWeaponAnimation()
	local iron = self:GetIronsights()

	if self:Clip1() == 0 then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_EMPTY)
	else
		self:SendWeaponAnim(iron and ACT_VM_PRIMARYATTACK_1 or ACT_VM_PRIMARYATTACK)
	end
	self.IdleActivity = (self:Clip1() == 0) and ACT_VM_IDLE_EMPTY or ACT_VM_IDLE
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
	self.IdleActivity = ACT_VM_IDLE
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
end

function SWEP:Deploy()
	self:SendWeaponAnim((self:Clip1() == 0) and ACT_VM_DRAW_EMPTY or ACT_VM_DRAW_DEPLOYED)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	self.BaseClass.Deploy(self)
	return true
end

SWEP.LowAmmoSoundThreshold = 0.5
SWEP.LowAmmoSoundHandgun = ")weapons/tfa/lowammo_indicator_handgun.wav"
SWEP.LastShot = ")weapons/tfa/lowammo_dry_handgun.wav"
function SWEP:EmitFireSound()
	local clip1, maxclip1 = self:Clip1(), self:GetMaxClip1()
	local mult = clip1 / maxclip1
	self:EmitSound(self.LowAmmoSoundHandgun, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
	if self:Clip1() <= 1 then
		self:EmitSound(self.LastShot, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
	end

	self:EmitSound(self.Primary.Sound, self.SoundFireLevel, 100 + (1 - (clip1 / maxclip1)) * 35, self.SoundFireVolume, CHAN_WEAPON)
end

sound.Add({
	name = 			"Pistol.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/pistols/pistol_boltback.wav"
})

sound.Add({
	name = 			"Pistol.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/pistols/pistol_boltrelease.wav"
})

sound.Add({
	name = 			"Pistol.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/pistols/pistol_magin.wav"
})

sound.Add({
	name = 			"Pistol.Magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/pistols/pistol_magout.wav"
})

sound.Add({
	name = 			"Pistol.Magrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/pistols/pistol_magrelease.wav"
})

sound.Add({
	name = 			"Pistol.MagHit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/pistols/pistol_maghit.wav"
})
