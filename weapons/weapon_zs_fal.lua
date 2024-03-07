AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_fal"))
SWEP.Description = (translate.Get("desc_fal"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70
	SWEP.ShowWorldModel = false

	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(1, -3, 1.5)
	SWEP.HUD3DAng = Angle(0, 180, 75)
	SWEP.HUD3DScale = 0.012
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "SEMI"
		elseif self:GetFireMode() == 1 then
			return "AUTO"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Semi-Automatic"
		elseif self:GetFireMode() == 1 then
			return "Automatic"
		end
	end

	SWEP.ViewModelBoneMods = {
		["A_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -90) },
		["A_Optic"] = { scale = Vector(0.88, 0.88, 0.88), pos = Vector(0, 0, 0.335), angle = Angle(0, 0, 0) },
		["A_Modkit"] = { scale = Vector(0.9, 0.92, 0.88), pos = Vector(0, 0.55, 0.182), angle = Angle(0, 0, 0) },
		["A_Suppressor"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(0, -1.8, 0.15), angle = Angle(0, 0, 0) },
		["A_LaserFlashlight"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, -1, 0.16), angle = Angle(0, 0, 160) }, -- Angle(0, 0, -20)
		["A_Foregrip"] = { scale = Vector(0.45, 0.45, 0.5), pos = Vector(0, 0, 0.15), angle = Angle(0, 0, 0) },
		["Magazine"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Trigger"] = { scale = Vector(1, 1, 1), pos = Vector(0.08, 0.05, 0), angle = Angle(0, 0, 0) },
		["Rounds"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0.4), angle = Angle(0, 0, 0) },
		["R Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5, -13.5, 0) },
		["R Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 15, 0) },
		["R Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 12, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-10, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.95, 0.95, 0.95), pos = Vector(0.3, -0.05, 0.1), angle = Angle(-1, -1, 0) },
        ["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0.25, 0, 0), angle = Angle(-6, 0, 0) }
	}
	
	SWEP.WorldModelBoneMods = {
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0.485, 0, 1.98), angle = Angle(0, 0, 0) }
	}
	
	SWEP.VElements = {
		["sights_folded"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_standard_fal.mdl", bone = "A_Optic", rel = "", pos = Vector(0, -0.98, -3.2), angle = Angle(90, 0, 90), size = Vector(0.88, 0.85, 0.92), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = true},
		["mag"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_magazine_fal_20.mdl", bone = "Magazine", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} , bonemerge = true, active = true },
	}

	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/w_ins2_fn_fal.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 0.96399998664856, -1.5), angle = Angle(0, -6, 180), size = Vector(0.89999997615814, 0.89999997615814, 0.89999997615814), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	function SWEP:GetDisplayAmmo(clip, spare, maxclip)
		local minus = self:GetAltUsage() and 0 or 1
		return math.max(0, (clip * 2) - minus), spare * 2, maxclip * 2
	end
	
	SWEP.VMPos = Vector(0.75, 0, -0.75)
	SWEP.VMAng = Angle(0, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_ins2_fn_fal.mdl"
SWEP.WorldModel = "models/weapons/w_ins2_fn_fal.mdl"
SWEP.UseHands = true

SWEP.SoundFireVolume = 1
SWEP.SoundFireLevel = 85
SWEP.SoundPitchMin = 85
SWEP.SoundPitchMax = 90

SWEP.HeadshotMulti = 2.23

SWEP.Primary.Sound = ")weapons/fal/fnfal_fire.wav" --fnfal_suppressed
SWEP.Primary.Damage = 57.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.14

SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.BulletType = SWEP.Primary.Ammo
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 2.5
SWEP.ConeMin = 1

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 5
--SWEP.MaxStock = 2

SWEP.FireAnimSpeed = 0.65

SWEP.ReloadSpeed = 0.82

SWEP.IronSightsPos = nil
SWEP.IronSightsAng = nil

SWEP.IdleActivity = ACT_VM_IDLE

SWEP.IronSightsPos = Vector(-3.235, 0, 1.35)
SWEP.IronSightsAng = Vector(-0.4, 0.05, 0)

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin
SWEP.DamageSave = SWEP.Primary.Damage
SWEP.DelaySave = SWEP.Primary.Delay

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.08, 1)

SWEP.IsShooting = 0

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.ConeMin = self.ConeMinSave
		self.ConeMax = self.ConeMaxSave
		self.Primary.Automatic = false
		self.Primary.Delay = self.DelaySave
	elseif self:GetFireMode() == 1 then
		self.ConeMin = self.ConeMinSave * 3.5
		self.ConeMax = self.ConeMaxSave * 3.5
		self.Primary.Automatic = true
		self.Primary.Delay = self.DelaySave * 0.7
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
end

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
end

function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_1 or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
		if CLIENT then
			self.ViewModelFOV = 75
		end
	end
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

sound.Add({
	name = 			"TFA_INS2.FAL.Draw",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fal/fnfal_draw.wav"	
})

sound.Add({
	name = 			"TFA_INS2.FAL.Boltback",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fal/fnfal_boltback.wav"	
})

sound.Add({
	name = 			"TFA_INS2.FAL.Boltrelease",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fal/fnfal_boltrelease.wav"	
})


sound.Add({
	name = 			"TFA_INS2.FAL.Empty",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fal/fnfal_empty.wav"	
})

sound.Add({
	name = 			"TFA_INS2.FAL.Magout",			
	channel = 		CHAN_AUTO,
	volume = 		1.0,
	sound = 			"weapons/fal/fnfal_magout.wav"	
})


sound.Add({
	name = 			"TFA_INS2.FAL.Magin",			
	channel = 		CHAN_AUTO,
	volume = 		1.0,
	sound = 			"weapons/fal/fnfal_magin.wav"	
})

sound.Add({
	name = 			"TFA_INS2.FAL.ROF",			
	channel = 		CHAN_AUTO,
	volume = 		1.0,
	sound = 			"weapons/fal/fnfal_rof.wav"	
})



