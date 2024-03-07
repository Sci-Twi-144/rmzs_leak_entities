AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_ender"))
SWEP.Description = (translate.Get("desc_ender"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70
	SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "Saiga12k"
	SWEP.HUD3DPos = Vector(1, 1.5, 0.5)
	SWEP.HUD3DAng = Angle(180, 0, -125)
	SWEP.HUD3DScale = 0.015

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Wrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(25, 0, 25) }
	}

	SWEP.VElements = {}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/weapons/w_saiga_v2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1, 3, -5), angle = Angle(-6, -1, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.VMPos = Vector(1.5, 4, -3)
	SWEP.VMAng = Angle(3, 2, 0)

	SWEP.WMPos = Vector(3.8, 0, -6)
	SWEP.WMAng = Angle(0, 2, 180)

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

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_saiga_v2.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/s12k/fire.wav"
SWEP.Primary.Damage = 10
SWEP.DamageSave = SWEP.Primary.Damage * (GAMEMODE.ZombieEscape and 4 or 1)
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 0.4

SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"

SWEP.ProceduralPattern = true
SWEP.PatternShape = "circle"

GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 5.125
SWEP.ConeMin = 4.175

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.WalkSpeed = SPEED_SLOWER
SWEP.IsShotgun = true

SWEP.Tier = 3

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

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.603, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.51, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 2)

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Primary.Damage = self.DamageSave
		self.ResistanceBypass = 1
		self.Primary.NumShots = 9
		self.ConeMax = self.ConeMaxSave
		self.ConeMin = self.ConeMinSave
		self.ClassicSpread = false
	elseif self:GetFireMode() == 1 then
		self.Primary.Damage = self.DamageSave * 6.35
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
	self:SetSwitchDelay(self:GetReloadFinish() + 0.2)
end

function SWEP:SecondaryAttack()
end

sound.Add({
	name 	=	"12k.Deploy",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound	=	"weapons/s12k/deploy.wav"	
})

sound.Add({
	name 	=	"12k.Magout",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/s12k/magout.wav"	
})

sound.Add({
	name 	=	"12k.Magin",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/s12k/magin.wav"	
})
-- check it
sound.Add({
	name 	=	"12k.Click",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/s12k/slidepull.wav"	
})
