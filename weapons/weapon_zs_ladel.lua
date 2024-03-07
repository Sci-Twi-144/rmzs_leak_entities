AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_ladel"))
SWEP.Description = (translate.Get("desc_ladel"))


if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_lab/ladel.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.809, 2.072, -6.882), angle = Angle(0.912, -90, 6.249), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_lab/ladel.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.009, 1.833, -6.954), angle = Angle(4.703, -180, 4.718), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 35
SWEP.MeleeRange = 58
SWEP.MeleeSize = 1

SWEP.Primary.Delay = 0.55

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingTime = 0

SWEP.BlockRotation = Angle(0, 15, -40)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.1
SWEP.BlockReduction = 4
SWEP.StaminaConsumption = 2

SWEP.WalkSpeed = SPEED_FASTER

SWEP.AllowQualityWeapons = true
SWEP.Culinary = true
SWEP.PArsenalModel = "models/props_lab/ladel.mdl"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.05, 1)

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/frying_pan/pan_hit-0"..math.random(4)..".ogg", 75, 140)
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/melee/frying_pan/pan_hit-0"..math.random(2)..".wav")
end
