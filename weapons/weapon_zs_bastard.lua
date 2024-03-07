AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_bastard"))
SWEP.Description = (translate.Get("desc_bastard"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "BastardGun"
	SWEP.HUD3DPos = Vector(2, -2, 5)
	SWEP.HUD3DAng = Angle(0, 180, 180)
	SWEP.HUD3DScale = 0.025
	SWEP.ViewModelBoneMods = {}

	function SWEP:DrawAds()

	end
	
	SWEP.VMPos = Vector(0, 0, 3.3)
	SWEP.VMAng = Angle(0, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/rmzs/weapons/bastard/c_bastard.mdl"
SWEP.WorldModel = "models/rmzs/weapons/bastard/w_bastard.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapons/bastardgun/shoot.wav"

SWEP.Primary.Damage = 18.25
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ResistanceBypass = 1.35
SWEP.HeadshotMulti = 2
SWEP.ReloadSpeed = 0.87

SWEP.ConeMax = 4.75
SWEP.ConeMin = 2.5

SWEP.CannotHaveExtendetMag = true
SWEP.WalkSpeed = SPEED_FAST
SWEP.Recoil = 1
SWEP.WepFail = 0.1

SWEP.IronSightsPos = Vector(-4.176, 4, 1.5)
SWEP.IronSightsAng = Vector(0.368, -0.197, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.75)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.5)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RECOIL, -0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_WEPFAIL, -0.01, 1)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	if CLIENT then
		local tbl = {}

		tbl["BastardMag"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
		for i = 1, 30 do
			tbl["Bullet".. i] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
		end
		self.ViewModelBoneMods = tbl
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	local stbl = E_GetTable(self)

	if (self:Clip1() < stbl.RequiredClip) and self:CanReload() then
		self:Reload()
		return false
	end

	if self:Clip1() < stbl.RequiredClip then
		self:EmitSound(stbl.DryFireSound, 75, 100, 0.7, CHAN_WEAPON)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, stbl.Primary.Delay))
		return false
	end

	if self:GetBlock() then
		self.Primary.Automatic = false
		self:EmitSound(")weapons/tfa/lowammo_dry_handgun.wav", self.SoundFireLevel, 100, self.SoundFireVolume)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, stbl.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	local owner = self:GetOwner()
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	
	local stbl = E_GetTable(self)
	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(stbl.Primary.Damage, stbl.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if math.random(100 - (100 - self.WepFail * 100)) == 1 and self:Clip1() < self.Primary.ClipSize * 0.5 then
		self:SetBlock(true)
	end

	if CLIENT then
		self.ViewModelBoneMods["BastardMag"].pos = Vector(0.2, 0 - (8 * (1 - (self:Clip1() / self.Primary.ClipSize))), -0.1)

		for i = 1, self.Primary.ClipSize - self:Clip1() do
			self.ViewModelBoneMods["Bullet".. i].pos = Vector(0, 999, 0)
		end
	end
end

function SWEP:CanReload()
	return self:GetNextReload() <= CurTime() and self:GetReloadFinish() == 0 and
		(
			self:GetMaxClip1() > 0 and self:Clip1() < self:GetPrimaryClipSize() and self:ValidPrimaryAmmo() and self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) > 0
			or self:GetMaxClip2() > 0 and self:Clip1() < self:GetMaxClip2() and self:ValidSecondaryAmmo() and self:GetOwner():GetAmmoCount(self:GetSecondaryAmmoType()) > 0
			or self:GetBlock() and self:Clip1() > 0
		)
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if owner:IsHolding() or self:GetCharging() then return end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	local stbl = E_GetTable(self)
	if self:CanReload() then
		self.Primary.Automatic = true
		if CLIENT then
			self.ViewModelBoneMods["BastardMag"].pos = Vector(0.3, 0 - (8 * (1 - (self:Clip1() / self.Primary.ClipSize))), -1 * (1 - self:Clip1() / self.Primary.ClipSize))
			timer.Simple(1, function()
				if self:IsValid() then
					local ammotype = self:GetPrimaryAmmoType()
					local spare = owner:GetAmmoCount(ammotype)
					local numbull = math.min(self.Primary.ClipSize - 1, spare + self:Clip1())
					self.ViewModelBoneMods["BastardMag"].pos = Vector(0.3, -8 + (8 * (numbull / self.Primary.ClipSize)), -0.1)
					for i = 1, self.Primary.ClipSize do
						self.ViewModelBoneMods["Bullet".. i].pos = Vector(0, 999, 0)
					end

					for i = self.Primary.ClipSize - numbull, self.Primary.ClipSize do
						self.ViewModelBoneMods["Bullet".. i].pos = Vector(0, 0, 0)
					end
				end
			end)
		end

		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(stbl.IdleAnimation)
		self:SetReloadStart(CurTime())

		self:SendReloadAnimation()
		self:ProcessReloadEndTime()

		owner:DoReloadEvent()

		self:EmitReloadSound()
	end
end

function SWEP:FinishReload()
	self.BaseClass.FinishReload(self)
	self:SetBlock(false)
end

function SWEP:SetBlock(bool)
	self:SetDTBool(10, bool)
end

function SWEP:GetBlock()
	return self:GetDTBool(10)
end

SWEP.LowAmmoSoundThreshold = 0.33
SWEP.LowAmmoSoundHandgun = ")weapons/tfa/lowammo_indicator_handgun.wav"
SWEP.LastShot = ")weapons/tfa/lowammo_dry_handgun.wav"
function SWEP:EmitFireSound()
	local clip1, maxclip1 = self:Clip1(), self:GetMaxClip1()
	local mult = clip1 / maxclip1
	self:EmitSound(self.LowAmmoSoundHandgun, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
	if self:Clip1() <= 1 then
		self:EmitSound(self.LastShot, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
	end
	self:EmitSound(self.Primary.Sound, self.SoundFireLevel, 100, self.SoundFireVolume, CHAN_WEAPON)
end

-- function SWEP:SendReloadAnimation()
    -- local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
	-- self.IdleActivity = ACT_VM_IDLE
    -- self:SendWeaponAnim(checkempty)
    -- self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
-- end

sound.Add({
	name = "BG.Clip",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapons/bastardgun/clip.wav"
})

sound.Add({
	name = "BG.ClipIn",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/bastardgun/clipin.wav"
})

sound.Add({
	name = "BG.ClipIn2",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/bastardgun/clipin2.wav"
})

sound.Add({
	name = "BG.ClipOut",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/bastardgun/clipout.wav"
})

sound.Add({
	name = "BG.ClipOut1",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/bastardgun/clipout1.wav"
})

sound.Add({
	name = "BG.ClipOut2",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/bastardgun/clipout2.wav"
})

sound.Add({
	name = "BG.Fix",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/bastardgun/fix.wav"
})

sound.Add({
	name = "BG.Fix1",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/bastardgun/fix1.wav"
})


sound.Add({
	name = "BG.Hit",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/bastardgun/hit.wav"
})

sound.Add({
	name = "BG.Boltpull",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/bastardgun/boltpull.wav"
})
