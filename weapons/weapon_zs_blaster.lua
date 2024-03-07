AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = (translate.Get("wep_blaster"))
SWEP.Description = (translate.Get("desc_blaster"))

if CLIENT then
    SWEP.ViewModelFOV = 56
	SWEP.ViewModelFlip = false
    SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "weapon"
	SWEP.HUD3DPos = Vector(1.25, 3.5, 0.5)
	SWEP.HUD3DAng = Angle(180, 0, -125)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(2.5, -4, -1.5)
	SWEP.VMAng = Vector(0, 0, 0)

    SWEP.VElements = {}
	 
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/tfa_ins2/w_m500.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1, -2.4), angle = Angle(-12, 1.2, 180), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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

--SWEP.ViewModel = "models/weapons/c_blaster/c_blaster.mdl"
--SWEP.WorldModel = "models/weapons/w_supershorty.mdl"

SWEP.ViewModel = "models/weapons/tfa_ins2/c_m500.mdl"
SWEP.WorldModel = "models/weapons/tfa_ins2/w_m500.mdl"
SWEP.UseHands = true

SWEP.HoldType = "shotgun"
SWEP.LoweredHoldType = "passive"

SWEP.CSMuzzleFlashes = true

SWEP.ReloadDelay = 0.5

SWEP.Primary.Sound = ")weapons/tfa_ins2/m500/m500_fp.wav" --m500_suppressed_fp
SWEP.Primary.Damage = 7.925
SWEP.DamageSave = SWEP.Primary.Damage
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 0.8

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 6.25
SWEP.ConeMin = 4.25

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.PumpActivity = ACT_SHOTGUN_RELOAD_FINISH

SWEP.IronSightsPos = Vector(-2.615, -6, 1.1)
SWEP.IronSightsAng = Vector(0.78, 0, 0)

SWEP.ReloadStartActivityEmpty = ACT_VM_RELOAD_EMPTY

SWEP.Tier = 1
SWEP.WalkSpeed = SPEED_SLOWER

SWEP.ProceduralPattern = true
SWEP.PatternShape = "circle"

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.SpreadPattern = {
    {0, 0},
    {-5, 0},
    {-4, 3},
    {0, 5},
    {4, 3},
    {5, 0},
    {4, -3},
    {0, -5},
    {-4, -3},
}

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_blareduct")

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Primary.Damage = self.DamageSave
		self.Primary.NumShots = 9
		self.ResistanceBypass = nil
		self.ConeMax = self.ConeMaxSave
		self.ConeMin = self.ConeMinSave
		self.ClassicSpread = false
	elseif self:GetFireMode() == 1 then
		self.Primary.Damage = self.DamageSave * 7.5
		self.Primary.NumShots = 1
		self.ResistanceBypass = 0.6
		self.ConeMin = self.ConeMinSave * 0.20
		self.ConeMax = self.ConeMaxSave * 0.35
		self.ClassicSpread = true
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
end


function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
    local time = self:GetNextPrimaryFire()
	timer.Simple(0.05, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
		end
	end)
end

sound.Add({
	name = 			"TFA_INS2.M500.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m500/m500_pumpback.wav"
})

sound.Add({
	name = 			"TFA_INS2.M500.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m500/m500_pumpforward.wav"
})

sound.Add({
	name = 			"TFA_INS2.M500.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m500/m500_empty.wav"
})

sound.Add({
	name = 			"TFA_INS2.M500.ShellInsert",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m500/m500_shell_insert_"..math.random(1, 3)..".wav"
})

sound.Add({
	name = 			"TFA_INS2.M500.ShellInsertSingle",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m500/m500_single_shell_insert_"..math.random(1, 3)..".wav"
})