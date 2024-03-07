AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_eraser"))
SWEP.Description = (translate.Get("desc_eraser"))
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 80
	SWEP.ShowWorldModel = false 

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(1.0, -2.5, 0.25)
	SWEP.HUD3DAng = Angle(180, 0, -115)
	SWEP.HUD3DScale = 0.011

	SWEP.VElements = {
    	--["suppressor"] = { type = "Model", model = "models/weapons/upgrades/a_suppressor_fiveseven.mdl", bone = "A_Muzzle", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = true, bodygroup = {}, active = false },
		--["laser"] = { type = "Model", model = "models/weapons/upgrades/a_flashlight_fiveseven_eft.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(-0.29, 0, 0), angle = Angle(0, 0, 180), size = Vector(0.76, 0.76, 0.76), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
        --["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Beam", rel = "laser", pos = Vector(-0.6, 0.05, -0.6), angle = Angle(0, 0, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false }
	}
	SWEP.WElements = {
    	--["laser"] = { type = "Model", model = "models/weapons/upgrades/a_flashlight_fiveseven_eft.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.942, 1.144, -2.381), angle = Angle(180, 180, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
        --["suppressor"] = { type = "Model", model = "models/weapons/upgrades/a_suppressor_fiveseven.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "weapon", pos = Vector(6.1, 0, 1.95), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["weapon"] = { type = "Model", model = "models/weapons/w_fiveseven_eft.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.1000000238419, -1.2999999523163), angle = Angle(0, -7, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.ViewModelBoneMods = {
		["Slide"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["R Hand"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["L Hand"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["R Forearm"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["L Forearm"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VMPos = Vector(1.25, 3,-0.75)
	SWEP.VMAng = Angle(0, 0, 0)
	local lBarrelOrigin = Vector(0, 0, 0)
    function SWEP:Think()
        if (self:Clip1() == 0) and not (self:GetReloadFinish() > 0) then
            self.ViewModelBoneMods[ "Slide" ].pos = LerpVector( FrameTime() * 16, self.ViewModelBoneMods[ "Slide" ].pos, Vector(0, 1.85, 0) )
        else
            self.ViewModelBoneMods[ "Slide" ].pos = LerpVector( FrameTime() * 16, self.ViewModelBoneMods[ "Slide" ].pos, lBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/v_fiveseven_eft.mdl"
SWEP.WorldModel = "models/weapons/w_fiveseven_eft.mdl"

SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/tfa_fiveseven_eft/fiveseven_eft_fire-1.wav"
SWEP.Primary.SilencedSound = ")weapons/tfa_fiveseven_eft/fnp_suppressed_tp.wav"

SWEP.Primary.Damage = 26
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.2

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.BulletType = SWEP.Primary.Ammo
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.FireAnimSpeed = 1

SWEP.ReloadSpeed = 1
SWEP.HeadshotMulti = 2.1

SWEP.ConeMax = 2.5
SWEP.ConeMin = 1.25

SWEP.Tier = 2
SWEP.ResistanceBypass = 0.8
SWEP.IsBranch = false

SWEP.IronSightsPos = Vector(-3.16, -2, 1.25)
SWEP.IronSightsAng = Vector(0.209, -0.138, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.08, 2)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 4)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.3, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.15, 1)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_cleanser")), (translate.Get("desc_cleanser")), function(wept)
	wept.ConeMax = wept.ConeMax * 1.5
	wept.ConeMin = wept.ConeMin * 2
	wept.IsBranch = true

	wept.BulletCallback = function(attacker, tr, dmginfo)
		dmginfo:SetDamage(dmginfo:GetDamage() + dmginfo:GetDamage() * math.min(GAMEMODE:GetWave(), 6)/7)
	end
end)

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_waraxe")), (translate.Get("desc_waraxe")), "weapon_zs_waraxe")
branch.Colors = {Color(130, 130, 240), Color(65, 65, 120), Color(39, 39, 90)}

SWEP.IronSightActivity  = ACT_VM_PRIMARYATTACK_1
SWEP.StandartIronsightsAnim = true
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
	self:EmitSound(self.Primary.Sound, self.SoundFireLevel, 100 + (1 - (clip1 / maxclip1)) * 70, self.SoundFireVolume, CHAN_WEAPON)
    --self:EmitSound(self.Primary.Sound, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), self.SoundFireVolume, 22)
end

function SWEP:ShootBullets(dmg, numbul, cone)
	if not self.IsBranch then
		local bonusdmg = 1 / self.Primary.ClipSize
		local mulcounter = (self:GetPrimaryClipSize() - self:Clip1() - 1) * bonusdmg
		dmg = dmg + dmg * mulcounter
	end

	BaseClass.ShootBullets(self, dmg, numbul, cone)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("TFA_INS2.Colt_M45.Magout")
		for i = 1, 2 do
			timer.Simple((self.ReloadTimerAnim - CurTime()) * (0.85 / i) * ((self:Clip1() == 0) and 0.9 or 1), function()
				if self:IsValid() then
					self:EmitSound((i == 2) and "TFA_INS2.Colt_M45.Magin" or "TFA_INS2.Colt_M45.MagHit")
				end
			end)
		end
	end
end

sound.Add({
	name = 			"TFA_INS2.Colt_M45.Magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_magout.wav"
})

sound.Add({
	name = 			"TFA_INS2.Colt_M45.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_magin.wav"
})

sound.Add({
	name = 			"TFA_INS2.Colt_M45.MagHit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_maghit.wav"
})