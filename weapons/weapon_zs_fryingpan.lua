AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_pan"))
SWEP.Description = (translate.Get("desc_pan"))

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_c17/metalpot002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.368, -9), angle = Angle(-90, 90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_c17/metalpot002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.368, -9), angle = Angle(-90, 90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_c17/metalpot002a.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 65
SWEP.MeleeRange = 55
SWEP.MeleeSize = 1.5

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingRotation = Angle(10, -20, -20)
SWEP.SwingTime = 0.8
SWEP.SwingHoldType = "grenade"

SWEP.BlockRotation = Angle(0, 15, -50)
SWEP.BlockOffset = Vector(3, 9, 5)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.6
SWEP.BlockReduction = 6
SWEP.StaminaConsumption = 8

SWEP.AllowQualityWeapons = true
SWEP.Culinary = true

GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_pot")), (translate.Get("desc_pot")), "weapon_zs_pot")

--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_KNOCK, 60, 1) -- какаято ебала
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_IMPACT_DELAY, -0.15)

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/frying_pan/pan_hit-0"..math.random(4)..".ogg")
end
