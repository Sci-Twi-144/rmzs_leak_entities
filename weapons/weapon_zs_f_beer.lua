AddCSLuaFile()

SWEP.Base = "weapon_zs_basefood"

SWEP.PrintName = "Beer"

if CLIENT then
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/garbage_glassbottle001a.mdl", bone = "ValveBiped.Grenade_Body", rel = "", pos = Vector(-0.5, 0, 0), angle = Angle(0, 0, 90), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/garbage_glassbottle001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2.5, -0.801), angle = Angle(180, 0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.ViewModel = "models/weapons/foods/c_gren_drink.mdl"
SWEP.WorldModel = "models/props_junk/garbage_glassbottle001a.mdl"

SWEP.Primary.Ammo = "foodbeer"

SWEP.FoodHealth = 7
SWEP.FoodEatTime = 3
SWEP.FoodIsLiquid = true
SWEP.Rarity = "common"
SWEP.FoodType = "drink"