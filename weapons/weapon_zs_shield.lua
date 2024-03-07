AddCSLuaFile()

SWEP.PrintName = "Sheild"
SWEP.Description = ""

if CLIENT then
	SWEP.ViewModelFOV = 55

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/shield/shield.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 3, -3), angle = Angle(0, 0, -10), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/shield/shield_wm.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, -1, 0), angle = Angle(0, 65, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/shield/shield_wm.mdl"
SWEP.UseHands = false

SWEP.MeleeDamage = 120
SWEP.MeleeRange = 50
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 185

SWEP.Primary.Delay = 2

SWEP.Tier = 4

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingTime = 0
SWEP.SwingHoldType = "melee"

SWEP.BlockRotation = Angle(0, 7, 0)
SWEP.BlockOffset = Vector(12, -3, 0)

SWEP.CanBlocking = true
SWEP.BlockStability = 2
SWEP.BlockReduction = 25
SWEP.StaminaConsumption = 1

SWEP.AllowQualityWeapons = true

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/plastic/plastic_barrel_impact_bullet1.wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/plastic/plastic_barrel_break1.wav")
end