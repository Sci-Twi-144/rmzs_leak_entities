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
	
	function SWEP:Draw3DHUD(vm, pos, ang)
		local wid, hei = 180, 64
		local x, y = wid * -0.6, hei * -0.5
		local spare = self:GetPrimaryAmmoCount()

		cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
		self:DrawAbilityBar3D(x, y - 30, hei, wid, Color(255, 0, 0), self:GetHeat(), 1, self:GetTumbler() and "OVERHEAT" or "HEAT")

		draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
		draw.SimpleTextBlurry(spare, spare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end

	function SWEP:Draw2DHUD()
		local screenscale = BetterScreenScale()

		local wid, hei = 180 * screenscale, 64 * screenscale
		local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
		local spare = self:GetPrimaryAmmoCount()

		self:DrawAbilityBar2D(x, y, hei, wid, Color(255, 0, 0), self:GetHeat(), 1, self:GetTumbler() and "OVERHEAT" or "HEAT")

		draw.RoundedBox(16, x, y, wid, hei, colBG)
		draw.SimpleTextBlurry(spare, spare >= 1000 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
SWEP.Primary.Delay = 0.09

SWEP.HeatBuildShort = 1.65
SWEP.HasAbility = true

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ResistanceBypass = 1.35
SWEP.HeadshotMulti = 1.5
SWEP.ReloadSpeed = 0.87

SWEP.ConeMax = 9.5
SWEP.ConeMin = 6

SWEP.TracerName = "tracer_firebullet"
SWEP.InnateTrinket = "trinket_flame_rounds"
SWEP.InnateBurnDamage = true 
SWEP.FlatBurnChance = 25
SWEP.BurnTickRateOff = 1.5

SWEP.CannotHaveExtendetMag = true
SWEP.WalkSpeed = SPEED_FAST
SWEP.Recoil = 0.85
SWEP.WepFail = 0.1

SWEP.IronSightsPos = Vector(-4.176, 4, 1.5)
SWEP.IronSightsAng = Vector(0.368, -0.197, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.75)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.5)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RECOIL, -0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_WEPFAIL, -0.01, 1)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Think()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	local stbl = E_GetTable(self)

	if self:GetReloadFinish() > 0 then
		if CurTime() >= self:GetReloadFinish() then
			self:FinishReload()
		end
	elseif stbl.IdleAnimation and stbl.IdleAnimation <= CurTime() then
		stbl.IdleAnimation = nil
		self:SendWeaponAnim(stbl.IdleActivity)
	end
	
	if self:GetTumbler() or (CurTime() > self.Time and self.Shoot) then
			local heatcountd = self:GetTumbler() and 0.008 or 0.015
	
			self:SetHeat(math.max(self:GetHeat() - heatcountd, 0))
	
			if self:GetHeat() <= 0 then
				self.Shoot = false
				self:SetHeat(0)
			end
	
			if self:GetHeat() <= 0 then
				self:SetTumbler(false)
			end
		end
	
end

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
	if not self:CanPrimaryAttack() or self:GetTumbler() then return end
	
		self.Time = CurTime() + 1
		self:SetHeat(math.min(self:GetHeat() + self.HeatBuildShort/25, 1))
		local owner = self:GetOwner()
		if self:GetHeat() >= 1 then
			self:SetTumbler(true)
			self:EmitSound("npc/scanner/scanner_siren1.wav", 75)
			if SERVER then 
				owner:TakeDamage(25 * (owner.SelfDamageMul or 0)) 
			end
		end
	
	local owner = self:GetOwner()
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	
	local stbl = E_GetTable(self)
	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(stbl.Primary.Damage, stbl.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

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

function SWEP:SetHeat(heat)
	self:SetDTFloat(12, heat)
end

function SWEP:GetHeat()
	return self:GetDTFloat(12)
end

function SWEP:SetValMulti(value)
	self:SetDTFloat(11, value)
end

function SWEP:GetValMulti()
	return self:GetDTFloat(11)
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
