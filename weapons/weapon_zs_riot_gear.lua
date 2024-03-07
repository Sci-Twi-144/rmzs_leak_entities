AddCSLuaFile()

SWEP.PrintName = "Riot Gear"
SWEP.Description = ""

if CLIENT then
    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 55
    SWEP.ShowViewModel = true
    SWEP.ShowWorldModel = true

	SWEP.VElements = {
		["shield"] = { type = "Model", model = "models/shield/shield.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(2, -21, 11.8), angle = Angle(68, 90, 68), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
		["shield"] = { type = "Model", model = "models/shield/shield_wm.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(14.5, -1, 1), angle = Angle(52.075, 83.774, 6.792), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, -3, 0), angle = Angle(0.7, -3, -0.7) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.467, 15.09, 19.401) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(4.311, -4.311, 0) },
		["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 38.802, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.311, -32.335, -17.246) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -58.204, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -64.671, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -32.335, -10.778) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -60, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -40.958, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -30, 2.156) },
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -58, 6.467) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -64.671, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.467, -17.246, 10.778) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(8.623, -58.204, 4.311) },
		["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -62.515, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-11, -23, 5) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-29, 2, -76) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-34, -73, 58) }
	}
end

SWEP.Base = "weapon_zs_basemelee"
SWEP.DamageType = DMG_CLUB
SWEP.ViewModel = "models/weapons/c_stunstick.mdl" 
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 67
SWEP.MeleeRange = 62
SWEP.MeleeSize = 1.25
SWEP.MeleeKnockBack = 100
SWEP.Primary.Delay = 1.1

SWEP.SwingRotation = Angle(12, -20, 7)
SWEP.SwingOffset = Vector(2, -3, 0)
SWEP.SwingTime = 0.5
SWEP.SwingHoldType = "grenade"

SWEP.BlockRotation = Angle(-20, -60, 26)
SWEP.BlockOffset = Vector(10, 8, -6)
SWEP.BlockHoldType = "melee2"

SWEP.Tier = 2

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.AllowQualityWeapons = true

SWEP.BashAdd = 206

SWEP.CanBlocking = true
SWEP.ShieldBlock = true
SWEP.BlockStability = 0.8
SWEP.BlockReduction = 15
SWEP.StaminaConsumption = 9

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1, 1)
--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_BLOCK_STABILITY, 0.15, 1)  

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_StunStick.Swing")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_StunStick.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("Weapon_StunStick.Melee_Hit")
end