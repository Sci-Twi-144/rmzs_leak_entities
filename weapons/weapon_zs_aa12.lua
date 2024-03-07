AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_base")

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.PrintName = (translate.Get("wep_aa12"))
SWEP.Description = (translate.Get("desc_aa12"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
    SWEP.ViewModelFOV = 65
	SWEP.ViewModelFlip = false
    SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "body"
	SWEP.HUD3DPos = Vector(1.25, -2.75, 5)
	SWEP.HUD3DAng = Angle(180, 0, -25)
	SWEP.HUD3DScale = 0.012

    SWEP.VElements = {}
	
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/tfa_ins2/w_aa12.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1, -0.5), angle = Angle(-10, -1, 178), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

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

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "SLUG"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "SLUG"
		end
	end	
end

SWEP.ViewModel = "models/weapons/tfa_ins2/c_aa12.mdl"
SWEP.WorldModel = "models/weapons/tfa_ins2/w_aa12.mdl"
SWEP.UseHands = true

SWEP.HoldType = "ar2"

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Sound = Sound(")weapons/tfa_ins2/aa12/shg21_fp_fire_1"..math.random(1,5)..".wav")

SWEP.Primary.Damage = 11.5
SWEP.DamageSave = SWEP.Primary.Damage * (GAMEMODE.ZombieEscape and 4 or 1)
SWEP.Primary.NumShots = 10
SWEP.Primary.Delay = 0.22

SWEP.Recoil = 1.25
SWEP.Tier = 6

SWEP.SpreadPattern = {
    {1, 0},
	{-1, 0},
    {-5, 0},
    {-4, 3},
    {0, 5},
    {4, 3},
    {5, 0},
    {4, -3},
    {0, -5},
    {-4, -3},
}

SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.DefaultClip = 20

SWEP.ConeMax = 7.28
SWEP.ConeMin = 3.66

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.IronSightsPos = Vector(-3.42, -4, -0.08)
SWEP.IronSightsAng = Vector(0.14, 0, 0)

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Primary.Damage = self.DamageSave
		self.ResistanceBypass = 1
		self.Primary.NumShots = 10
		self.ConeMax = self.ConeMaxSave
		self.ConeMin = self.ConeMinSave
	elseif self:GetFireMode() == 1 then
		self.Primary.Damage = self.DamageSave * 7.35
		self.ResistanceBypass = 0.6
		self.Primary.NumShots = 1
		self.ConeMax = self.ConeMaxSave * 0.35
		self.ConeMin = self.ConeMinSave * 0.20
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.075)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.03, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 4, 1)

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
end

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_1 or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:EmitReloadSound()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	local checkempty = (self:Clip1() == 0)
	if not checkempty then
		if IsFirstTimePredicted() then
			timer.Create("LeanIn", 0.4 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 87, 100, 1, CHAN_WEAPON + 21)
			end)
			timer.Create("WpnUp", 1 / reloadspeed, 1, function ()
				self:EmitSound("weapons/tfa_ins2/aa12/shg21_reload_fp_02_clipout.wav", 87, 100, 1, CHAN_WEAPON + 21)
			end)
			timer.Create("ClipOut", 1.23 / reloadspeed, 1, function ()
				self:EmitSound("weapons/tfa_ins2/aa12/shg21_reload_fp_01_wpnup.wav", 87, 100, 0.1, CHAN_WEAPON + 22)
			end)
			timer.Create("LeanIn2", 1.33 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 87, 100, 1, CHAN_WEAPON + 23)
			end)
			timer.Create("Holster", 2.2 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_weapon_holster.wav", 87, 100, 0.1, CHAN_WEAPON + 24)
			end)

			timer.Create("LeanIn3", 2.66 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 87, 100, 1, CHAN_WEAPON + 25)
			end)
			timer.Create("ClipIn", 3.8 / reloadspeed, 1, function ()
				self:EmitSound("weapons/tfa_ins2/aa12/shg21_reload_fp_03_clipin.wav", 87, 100, 1, CHAN_WEAPON + 26)
			end)
			timer.Create("ClipLock", 3.93 / reloadspeed, 1, function ()
				self:EmitSound("weapons/tfa_ins2/aa12/shg21_reload_fp_04_cliplock.wav", 87, 100, 1, CHAN_WEAPON + 27)
			end)
			timer.Create("LeanIn4", 4.7 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 75, 75, 1, CHAN_WEAPON + 28)
			end)
		end
	end
	--
	if checkempty then
		if  IsFirstTimePredicted() then
			timer.Create("LeanIn", 0.2 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 87, 100, 1, CHAN_WEAPON + 21)
			end)
			timer.Create("LeanIn2", 0.4 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 87, 100, 1, CHAN_WEAPON + 22)
			end)
			timer.Create("WpnUp", 1.26 / reloadspeed, 1, function ()
				self:EmitSound("weapons/tfa_ins2/aa12/shg21_reload_fp_01_wpnup.wav", 87, 100, 1, CHAN_WEAPON + 23)
			end)
			timer.Create("ClipOut", 1.66 / reloadspeed, 1, function ()
				self:EmitSound("weapons/tfa_ins2/aa12/shg21_reload_fp_02_clipout.wav", 87, 100, 1, CHAN_WEAPON + 24)
			end)
			timer.Create("Holster", 2.26 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_weapon_holster.wav", 70, 57, 0.1, CHAN_WEAPON + 25)
			end)

			timer.Create("LeanIn3", 3.4 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 87, 100, 1, CHAN_WEAPON + 26)
			end)
			timer.Create("ClipIn4", 3.73 / reloadspeed, 1, function ()
				self:EmitSound("weapons/tfa_ins2/aa12/shg21_reload_fp_03_clipin.wav", 87, 100, 1, CHAN_WEAPON + 27)
			end)
			timer.Create("ClipLock", 3.9 / reloadspeed, 1, function ()
				self:EmitSound("weapons/tfa_ins2/aa12/shg21_reload_fp_04_cliplock.wav", 87, 100, 0.1, CHAN_WEAPON + 28)
			end)
			timer.Create("LeanIn5", 4.2 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 87, 100, 1, CHAN_WEAPON + 29)
			end)
			
			timer.Create("LeanIn6", 4.73 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 87, 100, 1, CHAN_WEAPON + 30)
			end)
			
			timer.Create("BoltBack", 4.76 / reloadspeed, 1, function ()
				self:EmitSound("weapons/tfa_ins2/aa12/shg21_reload_fp_05_cockbk.wav", 87, 100, 1, CHAN_WEAPON + 31)
			end)
			timer.Create("BoltForward", 5.16 / reloadspeed, 1, function ()
				self:EmitSound("weapons/tfa_ins2/aa12/shg21_reload_fp_06_cockfwd.wav", 87, 100, 1, CHAN_WEAPON + 20)
			end)
			timer.Create("LeanIn7", 4.7 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 87, 100, 1, CHAN_WEAPON + 19)
			end)
			timer.Create("LeanIn8", 4.7 / reloadspeed, 1, function ()
				self:EmitSound("weapons/ins2/uni/uni_lean_in_0"..math.random(1, 4)..".wav", 87, 100, 1, CHAN_WEAPON + 18)
			end)
		end
	end
end

function SWEP:RemoveAllTimers()
	local checkempty = (self:Clip1() == 0)
	if checkempty then
		timer.Remove("LeanIn")
		timer.Remove("LeanIn2")
		timer.Remove("WpnUp")
		timer.Remove("ClipOut")
		timer.Remove("Holster")
		timer.Remove("LeanIn3")
		timer.Remove("ClipIn4")
		timer.Remove("ClipLock")
		timer.Remove("LeanIn5")
		timer.Remove("LeanIn6")
		timer.Remove("BoltBack")
		timer.Remove("BoltForward")
		timer.Remove("LeanIn7")
		timer.Remove("LeanIn8")
	else
		timer.Remove("LeanIn")
		timer.Remove("WpnUp")
		timer.Remove("ClipOut")
		timer.Remove("LeanIn2")
		timer.Remove("Holster")
		timer.Remove("LeanIn3")
		timer.Remove("ClipIn")
		timer.Remove("ClipLock")
		timer.Remove("LeanIn4")
	end
end

function SWEP:Holster()
	self:RemoveAllTimers()
	return BaseClass.Holster(self)
end

function SWEP:OnRemove()
	BaseClass.OnRemove(self)
	self:RemoveAllTimers()
end

sound.Add({
	name = 			"ash12.bolt",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/ash12/bolt.wav"
})

sound.Add({
	name = 			"ash12.boltempty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/ash12/boltempty.wav"
})

sound.Add({
	name = 			"ash12.draw",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/ash12/draw.wav"
})

sound.Add({
	name = 			"ash12.cloth",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/ash12/cloth.wav"
})

sound.Add({
	name = 			"ash12.dryfire",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/ash12/dryfire.wav"
})

sound.Add({
	name = 			"ash12.magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/ash12/magin.wav"
})

sound.Add({
	name = 			"ash12.magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/ash12/magout.wav"
})

sound.Add({
	name = 			"ash12.maghit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/ash12/maghit.wav"
})
