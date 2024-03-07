AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_thumper"))
SWEP.Description = (translate.Get("desc_thumper"))

SWEP.Slot = 4
SWEP.SlotPos = 0
if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(3, -1.5, 1.3)
	SWEP.HUD3DAng = Angle(0, -90, 55)
	SWEP.HUD3DScale = 0.015

	SWEP.WMPos = Vector(1, 2, 1)
	SWEP.WMAng = Angle(-9, 0, 180)
	SWEP.WMScale = 1.0

	SWEP.ShowWorldModel = false

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/weapons/w_thumper.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 2, 3), angle = Angle(-15, 5, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "CONTACT"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "CONTACT"
		end
	end	
end

SWEP.UseHands = true
SWEP.WorldModelFix = true

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "shotgun"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_thumper.mdl"
SWEP.WorldModel = "models/weapons/w_thumper.mdl"

SWEP.Primary.Sound = ")weapons/thumper/fire.wav"
SWEP.SoundFireVolume = 1.0
SWEP.SoundFireLevel = 140
SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.Damage = 86
SWEP.Primary.Delay = 0.9
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Projectile = "projectile_grenade_launcher"
SWEP.ProjectileVel = 1200

SWEP.ProjHasDMGRadius = true

SWEP.IronSightsPos = Vector(-1, 2, 0)
SWEP.IronSightsAng = Vector(8, 0, 0)

SWEP.ReloadDelay = 1.1

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 2

SWEP.IsAoe = true

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.Primary.Projectile = "projectile_grenade_launcher"
SWEP.Primary.ProjVelocity = 900

SWEP.Primary.ProjExplosionRadius = 68
SWEP.Primary.ProjExplosionTaper = 0.85

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.15, 1)

local mogus = 1
function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		mogus = 1
	elseif self:GetFireMode() == 1 then
		mogus = 0
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:SetSwitchDelay(0.1)
end

if SERVER then
	function SWEP:EntModify(ent)
		ent:SetDTBool(mogus, true)
	end
end

sound.Add({
	name 	=	"mw2_thumper_new.out",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound	=	"weapons/thumper/out.wav"	
})

sound.Add({
	name 	=	"mw2_thumper_new.insert",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/thumper/insert.wav"	
})

sound.Add({
	name 	=	"mw2_thumper_new.open",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/thumper/open1.wav"	
})

sound.Add({
	name 	=	"mw2_thumper_new.close",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/thumper/close.wav"	
})

sound.Add({
	name	=	"mw2_thumper_new.deploy",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/thumper/deploy.wav"	
})