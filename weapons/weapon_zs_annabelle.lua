AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = (translate.Get("wep_annabelle"))
SWEP.Description = (translate.Get("desc_annabelle"))

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.IronSightsPos = Vector(-2.787, -4, 1.899)
	SWEP.IronSightsAng = Vector(0.337, -0.99, 0)

	SWEP.HUD3DBone = "Base_Rifle"
	--SWEP.HUD3DPos = Vector(1.05, 8, 1.7)
	SWEP.HUD3DPos = Vector(1.2, 10, 1.7)
	SWEP.HUD3DAng = Angle(0, 180, 75)
	SWEP.HUD3DScale = 0.015

	--SWEP.VMPos = Vector(-4, -6, 2)
	--SWEP.VMAng = Vector(1, 0, 0)
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "BS"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "BS"
		end
	end	
end

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/annabelle/c_annabelle.mdl"
SWEP.WorldModel = "models/weapons/annabelle/w_annabelle.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = Sound("Weapon_Annabelle.Fire")
SWEP.Primary.Damage = 72
SWEP.DamageSave = SWEP.Primary.Damage
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.92

SWEP.ReloadDelay = 0.55

SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 25

SWEP.ConeMax = 4
SWEP.ConeMin = 0.25

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.ReloadSound = Sound("Weapon_Annabelle.Bullet_Load")
SWEP.PumpSound = Sound("Weapon_Annabelle.Bullet_Futz")
SWEP.BoltAction = ACT_SHOTGUN_PUMP

SWEP.WalkSpeed = SPEED_SLOW
SWEP.Tier = 2
SWEP.ResistanceBypass = 0.4

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.ClassicSpread = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.5, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.05, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1, 1)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_kar98")

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
        self.Primary.Damage = self.DamageSave
		self.Primary.NumShots = 1
		self.ConeMax = self.ConeMaxSave
		self.ConeMin = self.ConeMinSave
		self.ClassicSpread = true
	elseif self:GetFireMode() == 1 then
		self.Primary.Damage = self.DamageSave / 5
		self.Primary.NumShots = 6
		self.SpreadPattern = self:GeneratePattern("circle", self.Primary.NumShots)
		self.ConeMax = self.ConeMaxSave * 2
		self.ConeMin = self.ConeMinSave * 8
		self.ClassicSpread = false
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 75, math.random(95, 103), 0.8)
	--self:EmitSound("weapons/shotgun/shotgun_fire6.wav", 75, math.random(78, 81), 0.65, CHAN_WEAPON + 20)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
	end
end

function SWEP:Think()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	self.BaseClass.Think(self)
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
    local time = self:GetNextPrimaryFire()
	timer.Simple(0.15, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
		end
	end)
end

function SWEP:StopReloading()
	self:SetDTFloat(15, 0)
	self:SetDTBool(9, false)
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	local seq2 = self:SequenceDuration(self:SelectWeightedSequence(self.PumpActivity))
	local time = math.max(CurTime() + seq2 / reloadspeed, self:GetNextPrimaryFire())
	self:SetNextPrimaryFire(time)
	self:SetSwitchDelay(time)

	-- do the pump stuff if we need to
	if self:Clip1() > 0 then
		if self.PumpSound then
			self:EmitSound(self.PumpSound)
		end
		if self.BoltAction then
			timer.Simple(0.2, function()
			self:SendWeaponAnim(self.BoltAction)
			self:ProcessReloadAnim()
			end)
		end
		if self.PumpActivity then
			self:SendWeaponAnim(self.PumpActivity)
			self:ProcessReloadAnim()
		end
	end
end

sound.Add({
	name = "Weapon_Annabelle.Fire",
	channel = CHAN_STATIC,
	volume = 0.85,
	level = 79,
	pitch = {97, 103},
	sound = {
		"weapons/annabelle/annabelle_fire_player_01.wav",
		"weapons/annabelle/annabelle_fire_player_02.wav",
		"weapons/annabelle/annabelle_fire_player_03.wav",
		"weapons/annabelle/annabelle_fire_player_04.wav",
		"weapons/annabelle/annabelle_fire_player_05.wav",
		"weapons/annabelle/annabelle_fire_player_06.wav"
	}
})

sound.Add({
	name = "Weapon_Annabelle.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.85,
	level = 140,
	pitch = {97, 103},
	sound = {
		")weapons/annabelle/annabelle_fire_player_01.wav",
		")weapons/annabelle/annabelle_fire_player_02.wav",
		")weapons/annabelle/annabelle_fire_player_03.wav",
		")weapons/annabelle/annabelle_fire_player_04.wav",
		")weapons/annabelle/annabelle_fire_player_05.wav",
		")weapons/annabelle/annabelle_fire_player_06.wav"
	}
})

sound.Add({
	name = "Weapon_Annabelle.Lever_Down",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapons/annabelle/handling/annabelle_lever_down_01.wav",
		"weapons/annabelle/handling/annabelle_lever_down_02.wav",
		"weapons/annabelle/handling/annabelle_lever_down_03.wav"
	}
})
sound.Add({
	name = "Weapon_Annabelle.Lever_Up",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapons/annabelle/handling/annabelle_lever_up_01.wav",
		"weapons/annabelle/handling/annabelle_lever_up_02.wav",
		"weapons/annabelle/handling/annabelle_lever_up_03.wav"
	}
})
sound.Add({
	name = "Weapon_Annabelle.Bullet_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapons/annabelle/handling/annabelle_bullet_futz_01.wav",
		"weapons/annabelle/handling/annabelle_bullet_futz_02.wav",
		"weapons/annabelle/handling/annabelle_bullet_futz_03.wav",
		"weapons/annabelle/handling/annabelle_bullet_futz_04.wav",
		"weapons/annabelle/handling/annabelle_bullet_futz_05.wav",
		"weapons/annabelle/handling/annabelle_bullet_futz_06.wav"
	}
})
sound.Add({
	name = "Weapon_Annabelle.Bullet_Load",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapons/annabelle/handling/annabelle_bullet_load_01.wav",
		"weapons/annabelle/handling/annabelle_bullet_load_02.wav",
		"weapons/annabelle/handling/annabelle_bullet_load_03.wav",
		"weapons/annabelle/handling/annabelle_bullet_load_04.wav",
		"weapons/annabelle/handling/annabelle_bullet_load_05.wav",
		"weapons/annabelle/handling/annabelle_bullet_load_06.wav"
	}
})