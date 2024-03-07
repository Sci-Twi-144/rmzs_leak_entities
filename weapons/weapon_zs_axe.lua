AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_axe"))
SWEP.Description = (translate.Get("desc_axe"))

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/weapons/axe/w_axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 0.2, 10), angle = Angle(90, 90, -15), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/weapons/axe/w_axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 0.2, 10), angle = Angle(90, 90, -15), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props/cs_militia/axe.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 65
SWEP.MeleeRange = 60
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 140

SWEP.Primary.Delay = 1.2

SWEP.SwingTime = 0.6
SWEP.SwingRotation = Angle(10, -20, -20)
SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.SwingHoldType = "melee"

SWEP.BlockRotation = Angle(0, 15, -50)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockReduction = 6
SWEP.BlockStability = 0.2
SWEP.StaminaConsumption = 8

SWEP.HitDecal = "Manhackcut"

SWEP.AllowQualityWeapons = true

SWEP.PArsenalModel = "models/weapons/axe/w_axe.mdl"

GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_crowbar")), (translate.Get("desc_crowbar")), "weapon_zs_crowbar")
GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_pipe")), (translate.Get("desc_pipe")), "weapon_zs_pipe")
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 2, 1)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf_club/golf_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end
