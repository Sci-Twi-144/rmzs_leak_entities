AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_shtormbreaker"))
SWEP.Description = (translate.Get("desc_sawedoff"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.ViewModelFOV = 75
	SWEP.CSMuzzleFlashes = true

	SWEP.HUD3DBone = "Tube02"
	SWEP.HUD3DPos = Vector(1.5, -2, 1)
	SWEP.HUD3DAng = Angle(0, 180, 180)
	SWEP.HUD3DScale = 0.018

	SWEP.VMPos = Vector(2.68, 0, -0.64)
	SWEP.VMAng = Vector(-1.407, -0.704, 0)

	--SWEP.WMPos = Vector(1, 8, -1)
	--SWEP.WMAng = Angle(-15, 0, 180)
	--SWEP.WMScale = 1.1

	SWEP.VElements = {}
	SWEP.WElements = {
		--["weapon"] = { type = "Model", model = "models/weapons/tfa_nmrih/w_fa_sv10.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11, 1.2, -3), angle = Angle(-15, 2.5, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

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

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/rmzs/toz34/c_toz34.mdl"
SWEP.WorldModel	= "models/weapons/rmzs/toz34/w_toz34.mdl"
SWEP.ShowWorldModel = true

SWEP.UseHands = true
SWEP.HoldType = "shotgun"

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = "Arccw_FAS2_Weapon_TOZ34.Fire"
SWEP.Primary.SoundDouble = "Arccw_FAS2_Weapon_TOZ34.FireDouble"
SWEP.Primary.Damage = 34.6
SWEP.DamageSave = SWEP.Primary.Damage * (GAMEMODE.ZombieEscape and 4 or 1)
SWEP.Primary.NumShots = 6
SWEP.Primary.Delay = 0.85
SWEP.Secondary.Delay = 0.5

SWEP.Primary.Recoil = 12.5

SWEP.Primary.Ammo = "buckshot"

SWEP.ReloadSpeed = 1

SWEP.Primary.ClipSize = 2
SWEP.Primary.Automatic = false
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.IronSightsPos = Vector(-3.58, -2.638, 2.4)
SWEP.IronSightsAng = Vector(-0.071, 0.009, 0)

SWEP.ConeMax = 0.14
SWEP.ConeMin = 0.11

SWEP.ConeMax = 7
SWEP.ConeMin = 5.5

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.Recoil = 7.5

SWEP.Tier = 4

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.ProceduralPattern = true
SWEP.PatternShape = "rectangle"
SWEP.SecondPattern = true
SWEP.PatternShapeSecond = "circle"
SWEP.SpreadPatternSave = {}
SWEP.Secondary.NumShots = SWEP.Primary.NumShots  * 2
SWEP.IsShotgun = true

SWEP.WorldModelFix = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -1.125, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -1.069, 1)

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.SpreadPatternSave = self:GeneratePattern(self.PatternShape, self.Primary.NumShots)
end

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Primary.Damage = self.DamageSave
		self.ResistanceBypass = 1
		self.Primary.NumShots = 6
		self.ConeMax = self.ConeMaxSave
		self.ConeMin = self.ConeMinSave
		self.ClassicSpread = false
	elseif self:GetFireMode() == 1 then
		self.Primary.Damage = self.DamageSave * 3.35
		self.ResistanceBypass = 0.6
		self.Primary.NumShots = 1
		self.ConeMax = self.ConeMaxSave * 0.35
		self.ConeMin = self.ConeMinSave * 0.20
		self.ClassicSpread = true
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
		self:EmitSound(self.Primary.Sound)
		
		self.SpreadPattern = self.SpreadPatternSave
		
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())

		self:TakePrimaryAmmo(1)
		self:GetOwner():ViewPunch(1 * 0.5 * self.Primary.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:SecondaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		self:EmitSound(self:Clip1() > 1 and self.Primary.SoundDouble or self.Primary.Sound)

		local clip = self:Clip1()
		
		self.SpreadPattern = clip > 1 and self.SpreadPattern2 or self.SpreadPatternSave
		
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * clip, self:GetCone())

		self:TakePrimaryAmmo(clip)
		self:GetOwner():ViewPunch(clip * 0.5 * self.Primary.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		self:GetOwner():SetGroundEntity(NULL)
		self:GetOwner():SetVelocity(-50 * clip * self:GetOwner():GetAimVector())

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:SendReloadAnimation()
	if (self:Clip1() == 0) then
		self:SendWeaponAnim(ACT_VM_RELOAD_EMPTY)
	else
		self:SendWeaponAnim(ACT_VM_RELOAD)
	end
end

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz_fire.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.FireDouble",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz_fire_double.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Fire2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_obrez.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Close",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_close.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Open",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_open_start.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Open2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_open_finish.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Insert",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_shell_in1.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Remove",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_remove.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Pull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_pull_hammer.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Ejectorport",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_load_ejectorport.wav"
})


-- Звуки "Arccw_FAS2_Generic.Cloth_Movement" должны быть в Remington 870

sound.Add({
	name = 			"Arccw_FAS2_Generic.Magpouch_MG",
	channel = 		CHAN_ITEM3,
	volume = 		1.0,
	sound = "weapons/arccw_mifl/fas2/handling/generic_magpouch_mg1.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_Misc.Switch",
	channel = 		CHAN_ITEM3,
	volume = 		1.0,
	sound = "weapons/arccw_mifl/fas2/handling/switch.wav"
})